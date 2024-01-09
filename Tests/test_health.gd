extends GutTest
## Tests for health related things


var _player_scene: PackedScene = load("res://Entity/Player/Player.tscn")
var _enemy_scene: PackedScene = load("res://Entity/Enemy/Enemy.tscn")
var _battler_scene: PackedScene = load("res://Core/Battler.tscn")
var _player: Entity = null
var _enemy: Entity = null
var _enemy_2: Entity = null
var _battler: Battler = null
var _player_health_component: HealthComponent = null
var _enemy_health_component: HealthComponent = null


func before_each():
	_player = _player_scene.instantiate()
	_enemy = _enemy_scene.instantiate()
	_enemy_2 = _enemy_scene.instantiate()
	_battler = _battler_scene.instantiate()
	
	get_tree().root.add_child(_player)
	get_tree().root.add_child(_enemy)
	get_tree().root.add_child(_enemy_2)
	get_tree().root.add_child(_battler)
	
	_player_health_component = _player.get_health_component()
	_enemy_health_component = _enemy.get_health_component()


func after_each():
	_player.queue_free()
	_enemy.queue_free()
	_enemy_2.queue_free()
	_battler.queue_free()


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
	
func test_card_damage_all():
	_enemy.get_party_component().set_party([_enemy, _enemy_2])
	var card_damage_all: CardBase = load("res://Cards/Resource/Card_DamageAll.tres")
	
	card_damage_all.on_card_play(_player, _enemy)
	assert_eq(_enemy_health_component.current_health, 98.0)
	assert_eq(_enemy_2.get_health_component().current_health, 98.0)

func test_card_damage():
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")
	card_damage.on_card_play(_player, _enemy)
	
	assert_eq(_enemy_health_component.current_health, 97.0)

func test_card_damage_health():
	_player.get_health_component()._set_health(90.0)
	var card_damage_health: CardBase = load("res://Cards/Resource/Card_DamageHealth.tres")
	card_damage_health.on_card_play(_player, _enemy)
	
	assert_eq(_enemy_health_component.current_health, 90.0)

func test_card_poison():
	var card_poison: CardBase = load("res://Cards/Resource/Card_Poison.tres")
	
	assert_eq(_enemy.get_status_component().current_status.size(), 0)
	card_poison.on_card_play(_player, _enemy)
	assert_eq(_enemy.get_status_component().current_status.size(), 1)
	
	var status = _enemy.get_status_component().current_status[0]
	assert_is(status, Debuff_Poison)
	assert_eq(status.status_turn_duration, 3)
	
	_enemy.get_status_component().apply_turn_start_status()
	# May need to update once we have a better direction of what to do for poison, currently
	# it deals only 1 damage per turn
	assert_eq(_enemy_health_component.current_health, 99.0)

func test_card_damage_and_poison():
	var card_damage_and_poison: CardBase = load("res://Cards/Resource/Card_damage_and_poison.tres")

	assert_eq(_enemy.get_status_component().current_status.size(), 0)
	card_damage_and_poison.on_card_play(_player, _enemy)
	assert_eq(_enemy.get_status_component().current_status.size(), 1)
	assert_eq(_enemy_health_component.current_health, 99.0)
	
	var status = _enemy.get_status_component().current_status[0]
	assert_is(status, Debuff_Poison)
	assert_eq(status.status_turn_duration, 2)
	
	_enemy.get_status_component().apply_turn_start_status()
	# May need to update once we have a better direction of what to do for poison, currently
	# it deals only 1 damage per turn
	assert_eq(_enemy_health_component.current_health, 98.0)

func test_card_heal():
	var card_heal: CardBase = load("res://Cards/Resource/Card_Heal.tres")
	_player_health_component._set_health(95.0)
	card_heal.on_card_play(_player, _player)
	
	assert_eq(_player_health_component.current_health, 96.0)
