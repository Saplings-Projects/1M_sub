extends TestBase
## Test the stress mechanic

func test_stress_generation() -> void:
	var previous_stress: int = _enemy_stress_component.current_stress
	var stress_generation: int = 5
	_enemy_stress_component.stress_generation = stress_generation
	_enemy_stress_component.on_turn_start()
	assert_eq(_enemy_stress_component.current_stress - previous_stress, stress_generation)

	
func test_stress_card() -> void:
	var previous_stress: int = _enemy_stress_component.current_stress
	var card_stress: CardBase = load("res://Cards/Resource/Card_Stress_Damage.tres")
	card_stress.on_card_play(_player, _enemy)
	assert_eq(_enemy_stress_component.current_stress, previous_stress + 10)
	
	
func test_sooth_card() -> void:
	var previous_stress: int = _enemy_stress_component.current_stress
	var card_sooth: CardBase = load("res://Cards/Resource/Card_sooth.tres")
	card_sooth.on_card_play(_player, _enemy)
	assert_eq(_enemy_stress_component.current_stress, previous_stress - 10)
	
	
func test_sooth_buff() -> void:
	var previous_stress: int = _enemy_stress_component.current_stress
	var buff_sooth: CardBase = load("res://Cards/Resource/Card_buff_sooth.tres")
	StatModifiers.ready_card_modifier(buff_sooth)
	buff_sooth.on_card_play(_player, _player)
	var card_sooth: CardBase = load("res://Cards/Resource/Card_sooth.tres")
	card_sooth.on_card_play(_player, _enemy)
	assert_eq(_enemy_stress_component.current_stress, previous_stress - 11)
	
	
func test_sooth_debuff() -> void:
	var previous_stress: int = _enemy_stress_component.current_stress
	var debuff_sooth: CardBase = load("res://Cards/Resource/Card_debuff_sooth.tres")
	StatModifiers.ready_card_modifier(debuff_sooth)
	debuff_sooth.on_card_play(_player, _player)
	var card_sooth: CardBase = load("res://Cards/Resource/Card_sooth.tres")
	card_sooth.on_card_play(_player, _enemy)
	assert_eq(_enemy_stress_component.current_stress, previous_stress - 9)
