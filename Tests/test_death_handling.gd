extends TestBase
## Tests for things relating to death handling things


# @Override
func before_each() -> void:
	super()	
	# disconnecting signal as _combat_end_change_scene causes scene to be (re)loaded 
	# which if called from test actually starts the game and the test doesnt end
	watch_signals(PhaseManager)
	if PhaseManager.is_connected("on_combat_end", SceneController._combat_end_change_scene):
		PhaseManager.disconnect("on_combat_end", SceneController._combat_end_change_scene)

	
# No typing for argument as if it's already been freed it doesn't have one
@warning_ignore("untyped_declaration")
func _free_if_valid(node) -> void:
	if is_instance_valid(node):
		node.free()

# @Override
func after_each() -> void:
	_free_if_valid(_player)
	_free_if_valid(_enemy)
	_free_if_valid(_enemy_2)
	_battler.free()
	assert_no_new_orphans("Orphans still exist, please free up test resources.")
	

func test_player_death_during_enemy_turn() -> void:
	_player.get_health_component()._set_health(1.0)
	_battler._on_enemy_start_turn()
	assert_eq(_player.get_health_component().current_health, 0.)
	assert_signal_emitted_with_parameters(PhaseManager, "on_combat_end", [GlobalEnums.CombatResult.DEFEAT])


func test_check_and_handle_battle_end_player_death() -> void:
	_player_health_component._set_health(0.)
		
	_battler._check_and_handle_battle_end()

	assert_signal_emitted_with_parameters(PhaseManager, "on_combat_end", [GlobalEnums.CombatResult.DEFEAT])
	

func test_check_and_handle_battle_end_enemy_death() -> void:
	_battler._enemy_list = []
	
	_battler._check_and_handle_battle_end()

	assert_signal_emitted_with_parameters(PhaseManager, "on_combat_end", [GlobalEnums.CombatResult.VICTORY])
	
	
func test_handle_enemy_deaths_none() -> void:
	assert_eq(_enemy_list.size(), 2)
	_battler._handle_enemy_deaths()
	assert_eq(_enemy_list.size(), 2)
	
	
func test_handle_enemy_deaths_single() -> void:
	_enemy_health_component._set_health(0.)
	
	assert_eq(_enemy_list.size(), 2)
	_battler._handle_enemy_deaths()
	assert_eq(_enemy_list.size(), 1)
	assert_true(_enemy.is_queued_for_deletion())
	await get_tree().process_frame
	assert_false(is_instance_valid(_enemy))
	
	
func test_handle_enemy_deaths_all() -> void:
	_enemy_health_component._set_health(0.)
	_enemy_2_health_component._set_health(0.)
	
	assert_eq(_enemy_list.size(), 2)
	_battler._handle_enemy_deaths()
	assert_eq(_enemy_list.size(), 0)
	assert_true(_enemy.is_queued_for_deletion())
	assert_true(_enemy_2.is_queued_for_deletion())
	await get_tree().process_frame
	assert_false(is_instance_valid(_enemy))
	assert_false(is_instance_valid(_enemy_2))


func test_enemy_death_to_player_attack() -> void:
	_enemy_health_component._set_health(1.0)
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")
	
	assert_eq(_enemy_list.size(), 2)
	card_damage.on_card_play(_player, _enemy)
	assert_eq(_enemy_list.size(), 1)
	assert_true(_enemy.is_queued_for_deletion())
	await get_tree().process_frame
	assert_false(is_instance_valid(_enemy))


func test_all_enemy_death_to_player_attack_all() -> void:
	_enemy_health_component._set_health(1.0)
	_enemy_2_health_component._set_health(1.0)
	var card_damage_all: CardBase = load("res://Cards/Resource/Card_DamageAllEnemies.tres")
	
	assert_eq(_enemy_list.size(), 2)
	card_damage_all.on_card_play(_player, null)
	assert_eq(_enemy_list.size(), 0)
	assert_true(_enemy.is_queued_for_deletion())
	assert_true(_enemy_2.is_queued_for_deletion())
	await get_tree().process_frame
	assert_false(is_instance_valid(_enemy))
	assert_false(is_instance_valid(_enemy_2))



func test_enemy_death_to_poison() -> void:
	_enemy_health_component._set_health(1.0)
	var card_poison: CardBase = load("res://Cards/Resource/Card_Poison.tres")
	card_poison.on_card_play(_player, _enemy)

	assert_eq(_enemy_list.size(), 2)
	_battler._on_enemy_start_turn()
	assert_eq(_enemy_list.size(), 1)
	assert_true(_enemy.is_queued_for_deletion())
	await get_tree().process_frame
	assert_false(is_instance_valid(_enemy))


func test_enemy_death_to_expiring_poison() -> void:
	_enemy_health_component._set_health(1.0)
	var card_poison: CardBase = load("res://Cards/Resource/Card_Poison.tres")
	card_poison.on_card_play(_player, _enemy)
	_enemy.get_status_component().current_status[0].status_turn_duration = 1

	assert_eq(_enemy_list.size(), 2)
	assert_eq(_enemy.get_status_component().current_status.size(), 1)
	_battler._on_enemy_start_turn()
	assert_eq(_enemy.get_status_component().current_status.size(), 0)
	assert_eq(_enemy_list.size(), 1)
	assert_true(_enemy.is_queued_for_deletion())
	await get_tree().process_frame
	assert_false(is_instance_valid(_enemy))
	
	
func test_enemy_list_size_enemy_manager() -> void:
	_enemy_health_component._set_health(1.0)
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")
	
	assert_eq(_enemy_list.size(), 2)
	assert_eq(EnemyManager.enemy_list.size(), 2)
	card_damage.on_card_play(_player, _enemy)
	assert_eq(_enemy_list.size(), 1)
	assert_eq(EnemyManager.enemy_list.size(), 1)
	assert_true(_enemy.is_queued_for_deletion())
	await get_tree().process_frame
	assert_false(is_instance_valid(_enemy))
