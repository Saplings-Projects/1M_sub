extends TestBase


func _create_player():
	_player = _player_scene.instantiate()
	get_tree().root.add_child(_player)
	
	_player_health_component = _player.get_health_component()
	_player_stat_component = _player.get_stat_component()
	
	# NOTE: This resets the stats, so we don't want to call it when we're creating a player
	# for persistence testing.
	#_player_stat_component.get_stats().ready_entity_stats()


func after_each():
	super.after_each()
	pass


func test_persist_player_health():
	_player_health_component.deal_damage(5.0, _player)
	
	assert_eq(_player_health_component.current_health, 95.0)
	
	_player.free()
	_create_player()
	
	assert_eq(_player_health_component.current_health, 95.0)


func test_persist_strength_status():
	var strength_status: Buff_Strength = Buff_Strength.new()
	
	var stat_modifer: StatModifiers = StatModifiers.new()
	stat_modifer.permanent_add = 2.0
	stat_modifer.ready()
	strength_status.status_modifier_base_value = stat_modifer
	_player.get_status_component().add_status(strength_status, _player)
	
	var card_damage: CardBase = load("res://Cards/Resource/Card_Damage.tres")
	card_damage.card_effects_data[0].value = 2
	card_damage.on_card_play(_player, [_enemy])
	assert_eq(_enemy_health_component.current_health, 96.0)
	
	_player.free()
	_create_player()
	
	# player should still have their permanent buff after being destroyed and recreated
	card_damage.card_effects_data[0].value = 2
	card_damage.on_card_play(_player, [_enemy_2]) # enemy 2 has 50 health
	assert_eq(_enemy_2_health_component.current_health, 46.0)
