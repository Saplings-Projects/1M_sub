extends Node2D
class_name Battler
## Spawns enemies and controls the flow of battle.
## 
## This class holds a list of all the enemies, so it's a good central place to dispatch
## battle actions (player clicking on enemies, enemy attacks, applying status).

@export var enemies_to_summon: Array[PackedScene]
@export var enemy_spacing: float = 50.0
@export var enemy_attack_delay: float = 0.3

var _enemy_list: Array[Entity]
var _enemy_action_list: Array[EnemyAction] = []

func _ready() -> void:
	_summon_enemies()
	EnemyManager.enemy_list = _enemy_list
	
	# check if our player has been initialized already. If not, wait for the signal
	if (PlayerManager.player == null):
		PlayerManager.on_player_initialized.connect(_on_player_initialized)
	else:
		_on_player_initialized()
		
	PhaseManager.on_phase_changed.connect(_on_phase_changed)
	CardManager.on_card_container_initialized.connect(_on_card_container_initialized)
	CardManager.on_card_action_finished.connect(_handle_deaths.unbind(1))


func _summon_enemies() -> void:
	for enemy_index: int in enemies_to_summon.size():
		var enemy_instance: Node = enemies_to_summon[enemy_index].instantiate()
		add_child(enemy_instance)
		_enemy_list.append(enemy_instance)
		enemy_instance.get_click_handler().on_click.connect(_on_enemy_clicked.bind(enemy_instance))
		enemy_instance.position.x += enemy_spacing * enemy_index
	
	# setup party
	for enemy: Entity in _enemy_list:
		enemy.get_party_component().set_party(_enemy_list)


func _on_player_initialized() -> void:
	PlayerManager.player.get_click_handler().on_click.connect(_on_player_clicked)
	PlayerManager.player.get_party_component().add_party_member(PlayerManager.player)


func _on_phase_changed(new_phase: GlobalEnums.Phase, _old_phase: GlobalEnums.Phase) -> void:
	if new_phase == GlobalEnums.Phase.PLAYER_ATTACKING:
		_on_player_start_turn()
	
	if new_phase == GlobalEnums.Phase.ENEMY_ATTACKING:
		_on_enemy_start_turn()


func _on_card_container_initialized() -> void:
	if (!CardManager.is_discard_hand_signal_connected(_on_player_hand_discarded)):
		CardManager.connect_discard_hand_signal(_on_player_hand_discarded)


func _on_player_hand_discarded() -> void:
	PhaseManager.set_phase(GlobalEnums.Phase.ENEMY_ATTACKING)


## player start phase: apply status
func _on_player_start_turn() -> void:
	PlayerManager.player.get_status_component().apply_turn_start_status()
	PlayerManager.player.get_energy_component().on_turn_start()


## enemy start phase: apply status and attack player. Afterwards, set phase to player phase
## NOTE: these are applied in two separate loops just encase an enemy affects another member of their
## party with a status during their attack
func _on_enemy_start_turn() -> void:
	# apply status
	for enemy: Entity in _enemy_list:
		enemy.get_status_component().apply_turn_start_status()
		
	# if battle have ended, skip the rest of code
	if _handle_deaths():
		return
	
	# generate list of enemy actions
	for enemy: Enemy in _enemy_list:
		var enemy_attack: CardBase = enemy.get_behavior_component().attack
		var enemy_action: EnemyAction = EnemyAction.new(enemy, enemy_attack, PlayerManager.player)
		_enemy_action_list.append(enemy_action)
	
	# start the attack queue
	assert(_enemy_action_list.size() >= 0, "Enemy tried to attack while there were attacks queued!")
	_handle_enemy_attack_queue()


func _handle_enemy_attack_queue() -> void:
	# don't do anything if there are no attacks in queue
	if _enemy_action_list.is_empty():
		return
		
	var enemy_action: EnemyAction = _enemy_action_list[0]
	_enemy_action_list.remove_at(0)
	
	CardManager.on_card_action_finished.connect(_try_finish_enemy_attacks.unbind(1))
	enemy_action.execute()


## Called when an enemy action is finished.
## Tries to queue the next enemy action in the list if it exists.
func _try_finish_enemy_attacks() -> void:
	CardManager.on_card_action_finished.disconnect(_try_finish_enemy_attacks)
	
	await get_tree().create_timer(enemy_attack_delay).timeout
	
	if _enemy_action_list.size() > 0:
		_handle_enemy_attack_queue()
	else:
		PhaseManager.set_phase(GlobalEnums.Phase.PLAYER_ATTACKING)


## when player clicks themselves (eg: healing card)
func _on_player_clicked() -> void:
	_try_player_play_card_on_entity(PlayerManager.player)


## when player clicks an enemy (eg: damage card)
func _on_enemy_clicked(enemy: Enemy) -> void:
	_try_player_play_card_on_entity(enemy)


func _try_player_play_card_on_entity(entity: Entity) -> void:
	if CardManager.card_container.is_card_queued():
		var queued_card_data: CardBase = CardManager.card_container.queued_card.card_data
		var can_play: bool = queued_card_data.can_play_card(PlayerManager.player, entity)
		
		if can_play:
			CardManager.card_container.play_card(entity)

  
func _handle_enemy_deaths() -> void:
	var enemies_to_remove : Array[Entity] = []
	for enemy: Enemy in _enemy_list:
		if enemy.get_health_component().current_health == 0:
			enemies_to_remove.append(enemy)
			
	for enemy: Enemy in enemies_to_remove:
		_enemy_list.erase(enemy)
		enemy.queue_free()
		
	for enemy: Enemy in _enemy_list:
		enemy.get_party_component().set_party(_enemy_list)


## return TRUE if battle have ended either with victory or defeat
func _check_and_handle_battle_end() -> bool:
	if PlayerManager.player.get_health_component().current_health <= 0:
		PhaseManager.on_defeat.emit()
		return true
	if _enemy_list.is_empty():
		PhaseManager.on_event_win.emit()
		return true
    
	return false    


## return TRUE if battle have ended
func _handle_deaths() -> bool:
	_handle_enemy_deaths()
	return _check_and_handle_battle_end()


# TODO reset temporary stats at the end of the combat using EntityStats.reset_modifier_dict_temp_to_default()
