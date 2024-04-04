class_name TestBase extends GutTest
## Common test setup to be used by other tests

var _player_scene: PackedScene = load("res://Entity/Player/Player.tscn")
var _battler_scene: PackedScene = load("res://Core/Battler.tscn")
var _card_container_scene: PackedScene = load("res://Cards/CardContainer.tscn")
var _player: Player = null
var _enemy: Entity = null
var _enemy_2: Entity = null
var _battler: Battler = null
var _card_container: CardContainer = null
var _player_energy_component: EnergyComponent = null
var _player_health_component: HealthComponent = null
var _enemy_health_component: HealthComponent = null
var _enemy_2_health_component: HealthComponent = null
var _player_stat_component: StatComponent = null
var _enemy_stat_component: StatComponent = null
var _enemy_2_stat_component: StatComponent = null
var _player_status_component: StatusComponent = null
var _enemy_status_component: StatusComponent = null
var _enemy_2_status_component: StatusComponent = null
var _enemy_list: Array[Entity]


func before_each() -> void:
	_player = _player_scene.instantiate()
	_battler = _battler_scene.instantiate()
	_card_container = _card_container_scene.instantiate()
	
	get_tree().root.add_child(_player)
	get_tree().root.add_child(_battler)
	get_tree().root.add_child(_card_container)
	
	_enemy_list = _battler._enemy_list
	_enemy = _enemy_list[0] # enemy 1 has 100 HP
	_enemy_2 = _enemy_list[1] # enemy 2 50 HP
	
	_player_energy_component = _player.get_energy_component()
	_player_health_component = _player.get_health_component()
	_enemy_health_component = _enemy.get_health_component()
	_player_stat_component = _player.get_stat_component()
	_enemy_stat_component = _enemy.get_stat_component()
	_enemy_2_stat_component = _enemy_2.get_stat_component()
	_enemy_2_health_component = _enemy_2.get_health_component()
	_player_status_component = _player.get_status_component()
	_enemy_status_component = _enemy.get_status_component()
	_enemy_2_status_component = _enemy_2.get_status_component()

	_player_stat_component.stats.ready_entity_stats()
	_enemy_stat_component.stats.ready_entity_stats()
	_enemy_2_stat_component.stats.ready_entity_stats()
	
	# disable data saving so nothing is saved between tests
	_player._should_save_persistent_data = false
	_player_energy_component.ignore_cost = true
	CardManager.disable_card_animations = true

func after_each() -> void:
	_player.queue_free()
	_enemy.queue_free()
	_enemy_2.queue_free()
	_battler.queue_free()
	_card_container.queue_free()
	assert_no_new_orphans("Orphans still exist, please free up test resources.")
