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

func before_all():
	await PhaseManager.on_game_start


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


func test_take_damage():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 5.0
	deal_damage_data.attacker = _player

	_player_health_component.deal_damage(deal_damage_data)
	assert_eq(_player_health_component.current_health, 95.0)


func test_take_lots_of_damage():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 999999.0
	deal_damage_data.attacker = _player

	_player_health_component.deal_damage(deal_damage_data)
	assert_eq(_player_health_component.current_health, 0.0)


func test_null_attacker():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.attacker = null

	_player_health_component.deal_damage(deal_damage_data)
	assert_eq(_player_health_component.current_health, 50.0)


func test_heal():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = -50.0
	deal_damage_data.attacker = _player
	
	_player_health_component._set_health(50.0)
	_player_health_component.deal_damage(deal_damage_data)
	assert_eq(_player_health_component.current_health, 100.0)


func test_attack_enemy():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.attacker = _player

	_enemy_health_component.deal_damage(deal_damage_data)
	assert_eq(_enemy_health_component.current_health, 50.0)


# apply strength to player and damage enemy
func test_strength_buff():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.attacker = _player
	
	var strength_buff = Buff_Strength.new()
	strength_buff.buff_power = 1.0
	_player.get_buff_component().add_buff(strength_buff, _player)

	_enemy_health_component.deal_damage(deal_damage_data)
	assert_eq(_enemy_health_component.current_health, 49.0)


# apply weakness to player and damage enemy
func test_weakness_buff():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.attacker = _player
	
	var weakness_buff = Buff_Weakness.new()
	weakness_buff.buff_power = 1.0
	_player.get_buff_component().add_buff(weakness_buff, _player)

	_enemy_health_component.deal_damage(deal_damage_data)
	assert_eq(_enemy_health_component.current_health, 51.0)


# apply vulnerability to enemy and damage enemy
func test_vulnerability_buff():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.attacker = _player
	
	var vulnerability_buff = Buff_Vulnerability.new()
	vulnerability_buff.buff_power = 1.0
	_enemy.get_buff_component().add_buff(vulnerability_buff, _player)

	_enemy_health_component.deal_damage(deal_damage_data)
	assert_eq(_enemy_health_component.current_health, 49.0)


func test_vulnerability_weakness_strength():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 50.0
	deal_damage_data.attacker = _player
	
	var vulnerability_buff = Buff_Vulnerability.new()
	vulnerability_buff.buff_power = 1.0
	_enemy.get_buff_component().add_buff(vulnerability_buff, _player)

	var weakness_buff = Buff_Weakness.new()
	weakness_buff.buff_power = 2.0
	_player.get_buff_component().add_buff(weakness_buff, _player)
	
	var strength_buff = Buff_Strength.new()
	strength_buff.buff_power = 1.0
	_player.get_buff_component().add_buff(strength_buff, _player)

	_enemy_health_component.deal_damage(deal_damage_data)
	assert_eq(_enemy_health_component.current_health, 50.0)


func test_poison_buff():
	var poison_buff = Buff_Poison.new()
	poison_buff.buff_power = 1.0
	poison_buff.buff_turn_duration = 3.0
	poison_buff.buff_owner = _enemy
	_enemy.get_buff_component().add_buff(poison_buff, _player)

	poison_buff.on_turn_start()
	assert_eq(_enemy_health_component.current_health, 99.0)
