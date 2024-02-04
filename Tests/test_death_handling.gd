extends GutTest
## Tests for health related things


var _player_scene: PackedScene = load("res://Entity/Player/Player.tscn")
var _battler_scene: PackedScene = load("res://Core/Battler.tscn")
var _card_container_scene: PackedScene = load("res://Cards/CardContainer.tscn")
var _player: Entity = null
var _enemy: Entity = null
var _enemy_2: Entity = null
var _battler: Battler = null
var _card_container = null
var _player_health_component: HealthComponent = null
var _enemy_health_component: HealthComponent = null
var _enemy_2_health_component: HealthComponent = null
var _player_status_component: StatusComponent = null
var _enemy_status_component: StatusComponent = null
var _enemy_list: Array[Entity]


func before_each():
	_player = _player_scene.instantiate()
	_battler = _battler_scene.instantiate()
	_card_container = _card_container_scene.instantiate()
	_card_container.battler_refrence = _battler
	
	
	get_tree().root.add_child(_player)
	get_tree().root.add_child(_battler)
	get_tree().root.add_child(_card_container)
	
	_enemy_list = _battler._enemy_list
	_enemy = _enemy_list[0] # enemy 1 has 100 HP
	_enemy_2 = _enemy_list[1] # enemy 2 50 HP
	
	_player_health_component = _player.get_health_component()
	_enemy_health_component = _enemy.get_health_component()
	_enemy_2_health_component = _enemy_2.get_health_component()
	_player_status_component = _player.get_status_component()
	_enemy_status_component = _enemy.get_status_component()
	
	_player.get_stat_component().get_stats().ready_entity_stats()
	_enemy.get_stat_component().get_stats().ready_entity_stats()
	_enemy_2.get_stat_component().get_stats().ready_entity_stats()
	
	# disconnecting signal as _combat_end_change_scene causes scene to be (re)loaded 
	# which if called from test actually starts the game and the test doesnt end
	if PhaseManager.is_connected("on_combat_end", SceneController._combat_end_change_scene):
		PhaseManager.disconnect("on_combat_end", SceneController._combat_end_change_scene)

	
func _free_if_valid(node: Node):
	if is_instance_valid(node):
		node.queue_free()

func after_each():
	_free_if_valid(_player)
	_free_if_valid(_enemy)
	_free_if_valid(_enemy_2)
	_battler.queue_free()

func test_check_and_handle_battle_end_player_death():
	_player_health_component._set_health(0.)
	watch_signals(PhaseManager)
		
	_battler._check_and_handle_battle_end()

	assert_signal_emitted_with_parameters(PhaseManager, "on_combat_end", [Enums.CombatResult.DEFEAT])
	
func test_check_and_handle_battle_end_enemy_death():
	_battler._enemy_list = []
	watch_signals(PhaseManager)
	
	_battler._check_and_handle_battle_end()

	assert_signal_emitted_with_parameters(PhaseManager, "on_combat_end", [Enums.CombatResult.VICTORY])
	
	
func test_handle_enemy_deaths_none():
	assert_eq(_enemy_list.size(), 2)
	_battler._handle_enemy_deaths()
	assert_eq(_enemy_list.size(), 2)
	
	
func test_handle_enemy_deaths_single():
	_enemy_health_component._set_health(0.)
	
	assert_eq(_enemy_list.size(), 2)
	_battler._handle_enemy_deaths()
	assert_eq(_enemy_list.size(), 1)
	
	
func test_handle_enemy_deaths_all():
	_enemy_health_component._set_health(0.)
	_enemy_2_health_component._set_health(0.)
	
	assert_eq(_enemy_list.size(), 2)
	_battler._handle_enemy_deaths()
	assert_eq(_enemy_list.size(), 0)


func test_enemy_death_to_player_attack():
	_enemy_health_component._set_health(1.0)
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")
	
	assert_eq(_enemy_list.size(), 2)
	card_damage.on_card_play(_player, [_enemy])
	assert_eq(_enemy_list.size(), 1)


func test_enemy_death_to_poison():
	_enemy_health_component._set_health(1.0)
	var card_poison: CardBase = load("res://Cards/Resource/Card_Poison.tres")
	card_poison.on_card_play(_player, [_enemy])

	assert_eq(_enemy_list.size(), 2)
	_battler._on_enemy_start_turn()
	assert_eq(_enemy_list.size(), 1)
