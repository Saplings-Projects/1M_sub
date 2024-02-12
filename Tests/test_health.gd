extends TestBase
## Tests for health related things


func test_take_damage():
	var damage: float = 5.0
	var caster: Entity = _player

	_player_health_component.deal_damage(damage, caster)
	assert_eq(_player_health_component.current_health, 95.0)


func test_take_lots_of_damage():
	var damage: float = 999999.0
	var caster: Entity = _player

	_player_health_component.deal_damage(damage, caster)
	assert_eq(_player_health_component.current_health, 0.0)


func test_null_caster():
	var damage: float = 50.0
	var caster: Entity = null

	_player_health_component.deal_damage(damage, caster)
	assert_eq(_player_health_component.current_health, 50.0)


func test_heal():
	var damage: float = -50.0
	var caster: Entity = _player

	_player_health_component._set_health(50.0)
	_player_health_component.deal_damage(damage, caster)
	assert_eq(_player_health_component.current_health, 100.0)


func test_attack_enemy():
	var damage: float = 50.0
	var caster: Entity = _player

	_enemy_health_component.deal_damage(damage, caster)
	assert_eq(_enemy_health_component.current_health, 50.0)


func test_poison_status():
	var poison_status = Debuff_Poison.new()
	poison_status.status_power = 1.0
	poison_status.status_turn_duration = 3.0
	poison_status.status_target = _enemy
	poison_status.status_caster = _player
	_enemy_status_component.add_status(poison_status, _player)

	poison_status.on_turn_start()
	assert_eq(_enemy_health_component.current_health, 99.0)


# Test Card to Deal 2 damage to all enemies
func test_card_damage_all():
	_enemy.get_party_component().set_party(_enemy_list)
	var card_damage_all: CardBase = load("res://Cards/Resource/Card_DamageAll.tres")
	
	card_damage_all.on_card_play(_player, null)

	assert_eq(_enemy_health_component.current_health, 98.0)
	assert_eq(_enemy_2_health_component.current_health, 48.0)  # enemy 2 only has 50 HP


# Test Card to Deal 3 damage to an enemy
func test_card_damage():
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")

	card_damage.on_card_play(_player, _enemy)
	
	assert_eq(_enemy_health_component.current_health, 97.0)


# Test Card to deal damage to enemy based on amount of player health lost
func test_card_damage_health():
	_player.get_health_component()._set_health(90.0)
	var card_damage_health: CardBase = load("res://Cards/Resource/Card_DamageHealth.tres")

	card_damage_health.on_card_play(_player, _enemy)
	
	assert_eq(_enemy_health_component.current_health, 90.0)


# Test Card that applies 3 poison to enemy and does poison damage on enemy turn
func test_card_poison():
	var card_poison: CardBase = load("res://Cards/Resource/Card_Poison.tres")

	assert_eq(_enemy_status_component.current_status.size(), 0)
	card_poison.on_card_play(_player, _enemy)
	assert_eq(_enemy_status_component.current_status.size(), 1)

	var status = _enemy_status_component.current_status[0]
	assert_is(status, Debuff_Poison)
	assert_eq(status.status_turn_duration, 3)

	_enemy_status_component.apply_turn_start_status()
	# May need to update once we have a better direction of what to do for poison, currently
	# it deals only 1 damage per turn
	assert_eq(_enemy_health_component.current_health, 99.0)


# Test Card that deals 1 damage and applies 2 poison to enemy and does poison damage on enemy turn
func test_card_damage_and_poison():
	var card_damage_and_poison: CardBase = load("res://Cards/Resource/Card_damage_and_poison.tres")

	assert_eq(_enemy_status_component.current_status.size(), 0)
	card_damage_and_poison.on_card_play(_player, _enemy)
	assert_eq(_enemy_status_component.current_status.size(), 1)
	assert_eq(_enemy_health_component.current_health, 99.0)

	var status = _enemy_status_component.current_status[0]
	assert_is(status, Debuff_Poison)
	assert_eq(status.status_turn_duration, 2)

	_enemy_status_component.apply_turn_start_status()
	# May need to update once we have a better direction of what to do for poison, currently
	# it deals only 1 damage per turn
	assert_eq(_enemy_health_component.current_health, 98.0)


# Test Card that heals one HP to player
func test_card_heal():
	var card_heal: CardBase = load("res://Cards/Resource/Card_Heal.tres")
	_player_health_component._set_health(95.0)

	card_heal.on_card_play(_player, _player)
	
	assert_eq(_player_health_component.current_health, 96.0)
	

# Test card that deals 10 damage to every entity (player and enemies)
func test_card_damage_everything():
	var card_damage_everything: CardBase = load("res://Cards/Resource/Card_Damage_EVERYTHING.tres")
	card_damage_everything.on_card_play(_player, null)
	
	assert_eq(_player_health_component.current_health, 90.0)
	assert_eq(_enemy_health_component.current_health, 90.0)
	assert_eq(_enemy_2_health_component.current_health, 40.0)
