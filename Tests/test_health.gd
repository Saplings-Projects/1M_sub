extends TestBase
## Tests for health related things (dealing, taking damage, status dealing damage, etc...)


func test_take_damage() -> void:
	var damage: float = 5.0
	var caster: Entity = _player

	_player_health_component.deal_damage(damage, caster)
	assert_eq(_player_health_component.current_health, 95.0)


func test_take_lots_of_damage() -> void:
	var damage: float = 999999.0
	var caster: Entity = _player

	_player_health_component.deal_damage(damage, caster)
	assert_eq(_player_health_component.current_health, 0.0)


func test_null_caster() -> void:
	var damage: float = 50.0
	var caster: Entity = null

	_player_health_component.deal_damage(damage, caster)
	assert_eq(_player_health_component.current_health, 50.0)


func test_heal() -> void:
	var damage: float = -50.0
	var caster: Entity = _player

	_player_health_component._set_health(50.0)
	_player_health_component.deal_damage(damage, caster)
	assert_eq(_player_health_component.current_health, 100.0)


func test_attack_enemy() -> void:
	var damage: float = 50.0
	var caster: Entity = _player

	_enemy_health_component.deal_damage(damage, caster)
	assert_eq(_enemy_health_component.current_health, 50.0)


func test_poison_status() -> void:
	var poison_status: StatusBase = Debuff_Poison.new()
	poison_status.status_power = 1.0
	poison_status.status_turn_duration = 3
	poison_status.status_target = _enemy
	poison_status.status_caster = _player
	_enemy_status_component.add_status(poison_status, _player)

	poison_status.on_turn_start()
	assert_eq(_enemy_health_component.current_health, 99.0)


# Test Card to Deal 2 damage to all enemies
func test_card_damage_all() -> void:
	_enemy.get_party_component().set_party(_enemy_list)
	var card_damage_all: CardBase = load("res://Cards/Resource/Card_DamageAllEnemies.tres")
	
	card_damage_all.on_card_play(_player, null)

	assert_eq(_enemy_health_component.current_health, 98.0)
	assert_eq(_enemy_2_health_component.current_health, 48.0)  # enemy 2 only has 50 HP


# Test Card to Deal 3 damage to an enemy
func test_card_damage() -> void:
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")

	card_damage.on_card_play(_player, _enemy)
	
	assert_eq(_enemy_health_component.current_health, 97.0)


# Test Card to deal damage to enemy based on amount of player health lost
func test_card_damage_health() -> void:
	_player.get_health_component()._set_health(90.0)
	var card_damage_health: CardBase = load("res://Cards/Resource/Card_DamageHealth.tres")

	card_damage_health.on_card_play(_player, _enemy)
	
	assert_eq(_enemy_health_component.current_health, 90.0)


# Test Card that applies 3 poison to enemy and does poison damage on enemy turn
func test_card_poison() -> void:
	var card_poison: CardBase = load("res://Cards/Resource/Card_Poison.tres")

	assert_eq(_enemy_status_component.current_status.size(), 0)
	card_poison.on_card_play(_player, _enemy)
	assert_eq(_enemy_status_component.current_status.size(), 1)

	var status: StatusBase = _enemy_status_component.current_status[0]
	assert_is(status, Debuff_Poison)
	assert_eq(status.status_turn_duration, 3)

	_enemy_status_component.apply_turn_start_status()
	# May need to update once we have a better direction of what to do for poison, currently
	# it deals only 1 damage per turn
	assert_eq(_enemy_health_component.current_health, 99.0)


# Test Card that deals 1 damage and applies 2 poison to enemy and does poison damage on enemy turn
func test_card_damage_and_poison() -> void:
	var card_damage_and_poison: CardBase = load("res://Cards/Resource/Card_damage_and_poison.tres")

	assert_eq(_enemy_status_component.current_status.size(), 0)
	card_damage_and_poison.on_card_play(_player, _enemy)
	assert_eq(_enemy_status_component.current_status.size(), 1)
	assert_eq(_enemy_health_component.current_health, 99.0)

	var status: StatusBase = _enemy_status_component.current_status[0]
	assert_is(status, Debuff_Poison)
	assert_eq(status.status_turn_duration, 2)

	_enemy_status_component.apply_turn_start_status()
	# May need to update once we have a better direction of what to do for poison, currently
	# it deals only 1 damage per turn
	assert_eq(_enemy_health_component.current_health, 98.0)


# Test Card that heals one HP to player
func test_card_heal() -> void:
	var card_heal: CardBase = load("res://Cards/Resource/Card_Heal.tres")
	_player_health_component._set_health(95.0)

	card_heal.on_card_play(_player, _player)
	
	assert_eq(_player_health_component.current_health, 96.0)

func test_card_heal_with_strength_buff() -> void:
	var card_heal: CardBase = load("res://Cards/Resource/Card_Heal.tres")
	var buff: CardBase = load("res://Cards/Resource/Card_Strength.tres")


	_player_health_component._set_health(90.0)

	buff.on_card_play(_player, _player)
	card_heal.on_card_play(_player, _player)
	
	assert_eq(_player_health_component.current_health, 91.0)

# Test card that deals 10 damage to every entity (player and enemies)
func test_card_damage_everything() -> void:
	var card_damage_everything: CardBase = load("res://Cards/Resource/Card_Damage_EVERYTHING.tres")
	card_damage_everything.on_card_play(_player, null)
	
	assert_eq(_player_health_component.current_health, 90.0)
	assert_eq(_enemy_health_component.current_health, 90.0)
	assert_eq(_enemy_2_health_component.current_health, 40.0)
	

#Apply 3 poison effect randomly, each with 3 turns
func test_card_random_poison() -> void:
	var card_random_poison: CardBase = load("res://Cards/Resource/Card_PoisonRandom.tres")
	
	card_random_poison.on_card_play(_player, null)
	
	var poison_effect_turn_enemy_1 : int
	var poison_effect_turn_enemy_2 : int
	if _enemy_status_component.current_status.size() >= 1:
		poison_effect_turn_enemy_1 = _enemy_status_component.current_status[0].status_turn_duration
	if _enemy_2_status_component.current_status.size() >= 1:
		poison_effect_turn_enemy_2 = _enemy_2_status_component.current_status[0].status_turn_duration
	var total_turn_duration : int = poison_effect_turn_enemy_1 + poison_effect_turn_enemy_2
	
	assert_eq(total_turn_duration, 9)


# Deal 4 damages to the targeted enemy and the one on its right	
func test_card_fauna_sweep() -> void:
	var card_fauna_sweep: CardBase = load("res://Cards/Resource/Card_FaunaSweep.tres")
	
	card_fauna_sweep.on_card_play(_player, _enemy)
	
	assert_eq(_enemy_health_component.current_health, 96.0)
	assert_eq(_enemy_2_health_component.current_health, 46.0)
	
	card_fauna_sweep.on_card_play(_player, _enemy_2)
	
	assert_eq(_enemy_health_component.current_health, 96.0) 
	# Enemy 1 is on the left, we target enemy_2 so enemy 1 not affected
	assert_eq(_enemy_2_health_component.current_health, 42.0)
