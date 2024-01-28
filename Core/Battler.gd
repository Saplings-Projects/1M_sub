extends Node2D
class_name Battler
## Spawns enemies and controls the flow of battle.
## 
## This class holds a list of all the enemies, so it's a good central place to dispatch
## battle actions (player clicking on enemies, enemy attacks, applying status).


@export var enemies_to_summon: Array[PackedScene]
@export var enemy_spacing: float = 50.0
@export var enemy_attack_time: float = 1.0

var _enemy_list: Array[Entity]


func _ready() -> void:
	_summon_enemies()
	
	# check if our player has been initialized already. If not, wait for the signal
	if (PlayerManager.player == null):
		PlayerManager.on_player_initialized.connect(_on_player_initialized)
	else:
		_on_player_initialized()
		
	PhaseManager.on_phase_changed.connect(_on_phase_changed)
	CardManager.on_card_container_initialized.connect(_on_card_container_initialized)


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


func _on_phase_changed(new_phase: Enums.Phase, _old_phase: Enums.Phase) -> void:
	if new_phase == Enums.Phase.PLAYER_ATTACKING:
		_on_player_start_turn()
	
	if new_phase == Enums.Phase.ENEMY_ATTACKING:
		_on_enemy_start_turn()

func _on_card_container_initialized() -> void:
	if (!CardManager.is_discard_hand_signal_connected(_on_player_hand_discarded)):
		CardManager.connect_discard_hand_signal(_on_player_hand_discarded)

func _on_player_hand_discarded() -> void:
	PhaseManager.set_phase(Enums.Phase.ENEMY_ATTACKING)

# player start phase: apply status
func _on_player_start_turn() -> void:
	PlayerManager.player.get_status_component().apply_turn_start_status()


# enemy start phase: apply status and attack player. Afterwards, set phase to player phase
# NOTE: these are applied in two separate loops just encase an enemy affects another member of their
# party with a status during their attack
func _on_enemy_start_turn() -> void:
	# apply status
	for enemy: Entity in _enemy_list:
		enemy.get_status_component().apply_turn_start_status()
	
	# enemy attack
	for enemy: Entity in _enemy_list:
		var enemy_attack: CardBase = enemy.get_behavior_component().attack
		var can_attack: bool = enemy_attack.can_play_card(enemy, PlayerManager.player)
		
		assert(can_attack == true, "Enemy failed to attack.")
		
		if can_attack:
			enemy_attack.on_card_play(enemy, [PlayerManager.player])
	
	# TODO: temporary delay so we can see the draw pile and discard pile working
	await get_tree().create_timer(enemy_attack_time).timeout
	
	PhaseManager.set_phase(Enums.Phase.PLAYER_ATTACKING)


# when player clicks themselves (eg: healing card)
func _on_player_clicked() -> void:
	_try_player_play_card_on_entity(PlayerManager.player)


# when player clicks an enemy (eg: damage card)
func _on_enemy_clicked(enemy: Enemy) -> void:
	_try_player_play_card_on_entity(enemy)


func _try_player_play_card_on_entity(entity: Entity) -> void:
	if CardManager.card_container.is_card_queued():
		var queued_card_data: CardBase = CardManager.card_container.queued_card.card_data
		var can_play: bool = queued_card_data.can_play_card(PlayerManager.player, entity)
		
		if can_play:
			CardManager.card_container.play_card([entity])
			
func get_all_targets(application_type : Enums.ApplicationType) -> Array[Entity]:
	var all_target : Array[Entity]
	
	match application_type:
		Enums.ApplicationType.ALL:
			all_target = _enemy_list
			all_target += [PlayerManager.player]
		Enums.ApplicationType.ENEMY_ONLY:
			all_target = _enemy_list
		Enums.ApplicationType.FRIENDLY_ONLY:
			all_target = [PlayerManager.player]
			
	return all_target
  
# TODO condition check for killing enemies and removing them from the combat
# TODO condition check for killing player and ending the combat
# TODO condition check for killing all enemies and ending the combat
# TODO reset temporary stats at the end of the combat using EntityStats.reset_modifier_dict_temp_to_default()
