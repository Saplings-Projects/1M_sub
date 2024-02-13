extends TestBase


func before_all():
	SaveManager.save_to_file = false


func after_all():
	pass


func _create_player():
	_player = _player_scene.instantiate()
	get_tree().root.add_child(_player)
	_player_health_component = _player.get_health_component()
	_player_stat_component.get_stats().ready_entity_stats()


func test_persist_player_health():
	_player_health_component.deal_damage(5.0, _player)
	
	assert_eq(_player_health_component.current_health, 95.0)
	
	_player.free()
	_create_player()
	
	assert_eq(_player_health_component.current_health, 95.0)
