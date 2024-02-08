extends GutTest
## Tests for health related things


var _player_scene: PackedScene = load("res://Entity/Player/Player.tscn")
var _enemy_scene: PackedScene = load("res://Entity/Enemy/Enemy.tscn")
var _battler_scene: PackedScene = load("res://Core/Battler.tscn")
var _player: Entity = null
var _enemy: Entity = null
var _battler: Battler = null
var _player_health_component: HealthComponent = null
var _enemy_health_component: HealthComponent = null


func before_each():
	_player = _player_scene.instantiate()
	_enemy = _enemy_scene.instantiate()
	_battler = _battler_scene.instantiate()
	
	get_tree().root.add_child(_player)
	get_tree().root.add_child(_enemy)
	get_tree().root.add_child(_battler)
	
	_player_health_component = _player.get_health_component()
	_enemy_health_component = _enemy.get_health_component()


func after_each():
	_player.queue_free()
	_enemy.queue_free()
	_battler.queue_free()
	assert_no_new_orphans("Orphans still exist, please free up test resources.")


func test_take_damage():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 5.0
	deal_damage_data.caster = _player

	_player_health_component.deal_damage(deal_damage_data)
	assert_eq(_player_health_component.current_health, 95.0)


func test_take_lots_of_damage():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 999999.0
	deal_damage_data.caster = _player

	_player_health_component.deal_damage(deal_damage_data)
	assert_eq(_player_health_component.current_health, 0.0)


func test_null_caster():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.caster = null

	_player_health_component.deal_damage(deal_damage_data)
	assert_eq(_player_health_component.current_health, 50.0)


func test_heal():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = -50.0
	deal_damage_data.caster = _player
	
	_player_health_component._set_health(50.0)
	_player_health_component.deal_damage(deal_damage_data)
	assert_eq(_player_health_component.current_health, 100.0)


func test_attack_enemy():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.caster = _player

	_enemy_health_component.deal_damage(deal_damage_data)
	assert_eq(_enemy_health_component.current_health, 50.0)


# apply strength to player and damage enemy
func test_strength_status():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.caster = _player
	
	var strength_status = Buff_Strength.new()
	strength_status.status_power = 1.0
	_player.get_status_component().add_status(strength_status, _player)

	_enemy_health_component.deal_damage(deal_damage_data)
	assert_eq(_enemy_health_component.current_health, 49.0)


# apply weakness to player and damage enemy
func test_weakness_status():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.caster = _player
	
	var weakness_status = Debuff_Weakness.new()
	weakness_status.status_power = 1.0
	_player.get_status_component().add_status(weakness_status, _player)

	_enemy_health_component.deal_damage(deal_damage_data)
	assert_eq(_enemy_health_component.current_health, 51.0)


# apply vulnerability to enemy and damage enemy
func test_vulnerability_status():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.caster = _player
	
	var vulnerability_status = Debuff_Vulnerability.new()
	vulnerability_status.status_power = 1.0
	_enemy.get_status_component().add_status(vulnerability_status, _player)

	_enemy_health_component.deal_damage(deal_damage_data)
	assert_eq(_enemy_health_component.current_health, 49.0)


func test_vulnerability_weakness_strength():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.caster = _player
	
	var vulnerability_status = Debuff_Vulnerability.new()
	vulnerability_status.status_power = 1.0
	_enemy.get_status_component().add_status(vulnerability_status, _player)

	var weakness_status = Debuff_Weakness.new()
	weakness_status.status_power = 2.0
	_player.get_status_component().add_status(weakness_status, _player)
	
	var strength_status = Buff_Strength.new()
	strength_status.status_power = 1.0
	_player.get_status_component().add_status(strength_status, _player)

	_enemy_health_component.deal_damage(deal_damage_data)
	assert_eq(_enemy_health_component.current_health, 50.0)


func test_poison_status():
	var poison_status = Debuff_Poison.new()
	poison_status.status_power = 1.0
	poison_status.status_turn_duration = 3.0
	poison_status.status_owner = _enemy
	_enemy.get_status_component().add_status(poison_status, _player)

	poison_status.on_turn_start()
	assert_eq(_enemy_health_component.current_health, 99.0)
