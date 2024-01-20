extends GutTest

var _player_scene: PackedScene = load("res://Entity/Player/Player.tscn")
var _enemy_scene: PackedScene = load("res://Entity/Enemy/Enemy.tscn")
var _battler_scene: PackedScene = load("res://Core/Battler.tscn")
var _player: Entity = null
var _enemy: Entity = null
var _battler: Battler = null
var _player_health_component: HealthComponent = null
var _enemy_health_component: HealthComponent = null
var _player_stat_component: StatComponent = null
var _enemy_stat_component: StatComponent = null


func before_each():
	_player = _player_scene.instantiate()
	_enemy = _enemy_scene.instantiate()
	_battler = _battler_scene.instantiate()
	
	get_tree().root.add_child(_player)
	get_tree().root.add_child(_enemy)
	get_tree().root.add_child(_battler)
	
	_player_health_component = _player.get_health_component()
	_enemy_health_component = _enemy.get_health_component()
	_player_stat_component = _player.get_stat_component()
	_enemy_stat_component = _enemy.get_stat_component()


func after_each():
	_player.queue_free()
	_enemy.queue_free()
	_battler.queue_free()


func test_possible_modifier_size():
	var expected_size: int = 4
	var actual_size: int = GlobalVar.POSSIBLE_MODIFIER_NAMES.size()
	assert_eq(actual_size, expected_size, "Expected %s possible modifiers but got %s instead" % [expected_size, actual_size])


func test_offense_dict_size():
	var offense_dict_size_player: int = _player_stat_component.get_stats()._offense_modifier_dict.stat_dict.size()
	var offense_dict_size_enemy: int = _enemy_stat_component.get_stats()._offense_modifier_dict.stat_dict.size()
	var modifier_dict_size: int = GlobalVar.POSSIBLE_MODIFIER_NAMES.size()
	var assert_false_string: String = "Expected offense_dict_size to be %s (POSSIBLE_MODIFIER_NAMES.size()) but got %s instead for entity %s"
	assert_eq(offense_dict_size_player, modifier_dict_size, assert_false_string % [modifier_dict_size, offense_dict_size_player, "player"])
	assert_eq(offense_dict_size_enemy, modifier_dict_size, assert_false_string % [modifier_dict_size, offense_dict_size_enemy, "enemy"])


func test_defense_dict_size():
	var defense_dict_size_player: int = _player_stat_component.get_stats()._defense_modifier_dict.stat_dict.size()
	var defense_dict_size_enemy: int = _enemy_stat_component.get_stats()._defense_modifier_dict.stat_dict.size()
	var modifier_dict_size: int = GlobalVar.POSSIBLE_MODIFIER_NAMES.size()
	var assert_false_string: String = "Expected defense_dict_size to be %s (POSSIBLE_MODIFIER_NAMES.size()) but got %s instead for entity %s"
	assert_eq(defense_dict_size_player, modifier_dict_size, assert_false_string % [modifier_dict_size, defense_dict_size_player, "player"])
	assert_eq(defense_dict_size_enemy, modifier_dict_size, assert_false_string % [modifier_dict_size, defense_dict_size_enemy, "enemy"])


# apply strength to player and damage enemy
func test_strength_status():
	var strength_status: Buff_Strength = Buff_Strength.new()
	# add 1 damage offense on the player
	strength_status.status_modifier_base_value = StatModifiers.new(0,1,1,1)
	_player.get_status_component().add_status(strength_status, _player)
	
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")
	card_damage.card_effects_data[0].value = 50 # modified for the test
	card_damage.on_card_play(_player, _enemy)
	assert_eq(_enemy_health_component.current_health, 49.0)


# apply weakness to player and damage enemy
func test_weakness_status():
	var weakness_status: Debuff_Weakness = Debuff_Weakness.new()
	# remove 1 damage offense on the player
	weakness_status.status_modifier_base_value = StatModifiers.new(0,1,-1,1)
	_player.get_status_component().add_status(weakness_status, _player)
	
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")
	card_damage.card_effects_data[0].value = 50 # modified for the test
	card_damage.on_card_play(_player, _enemy)
	assert_eq(_enemy_health_component.current_health, 51.0)


# apply vulnerability to enemy and damage enemy
func test_vulnerability_status():
	var vulnerability_status: Debuff_Vulnerability = Debuff_Vulnerability.new()
	# remove 1 damage defense on the enemy
	vulnerability_status.status_modifier_base_value = StatModifiers.new(0,1,-1,1)
	_enemy.get_status_component().add_status(vulnerability_status, _player)
	
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")
	card_damage.card_effects_data[0].value = 50 # modified for the test
	card_damage.on_card_play(_player, _enemy)
	assert_eq(_enemy_health_component.current_health, 49.0)


func test_strength_weakness_vulnerability():
	var strength_status: Buff_Strength = Buff_Strength.new()
	# add 1 damage offense on the player
	strength_status.status_modifier_base_value = StatModifiers.new(0,1,1,1)
	_player.get_status_component().add_status(strength_status, _player)
	
	var weakness_status: Debuff_Weakness = Debuff_Weakness.new()
	# remove 1 damage offense on the player
	weakness_status.status_modifier_base_value = StatModifiers.new(0,1,-1,1)
	_player.get_status_component().add_status(weakness_status, _player)
	
	var vulnerability_status: Debuff_Vulnerability = Debuff_Vulnerability.new()
	# remove 1 damage defense on the enemy
	vulnerability_status.status_modifier_base_value = StatModifiers.new(0,1,-1,1)
	_enemy.get_status_component().add_status(vulnerability_status, _player)
	
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")
	card_damage.card_effects_data[0].value = 50 # modified for the test
	card_damage.on_card_play(_player, _enemy)
	assert_eq(_enemy_health_component.current_health, 49.0)
	# final health is 49 because original is 100, we do 50 damage
	# we add 1 damage because of strength, remove 1 because of weakness
	# and add 1 because of vulnerability (remove 1 defense on the enemy)

func test_remove_one_status():
	var strength_status: Buff_Strength = Buff_Strength.new()
	# add 1 damage offense on the player
	strength_status.status_modifier_base_value = StatModifiers.new(0,1,1,1)
	_player.get_status_component().add_status(strength_status, _player)
	
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")
	card_damage.on_card_play(_player, _enemy)
	assert_eq(_enemy_health_component.current_health, 96.0) 
	# 100 (base health) - (3 (base damage) + 1 (strength))
	
	_player.get_status_component().remove_status(strength_status)
	assert_eq(_player.get_status_component().current_status.size(), 0)
	
	card_damage.on_card_play(_player, _enemy)
	assert_eq(_enemy_health_component.current_health, 93.0)
	# 96 (previous health) - 3 (base damage)
	# we don't have the strength bonus of +1 damage anymore
	
