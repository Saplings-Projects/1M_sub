extends GutTest


var _player_scene: PackedScene = load("res://Entity/Player/Player.tscn")
var _player: Entity = null
var _player_health_component: HealthComponent = null


func before_all():
	SaveManager.save_to_file = false


func after_all():
	pass


func before_each():
	_create_player()
	_player_health_component.set_health(100.0)


func after_each():
	_player.queue_free()


func _create_player():
	_player = _player_scene.instantiate()
	
	get_tree().root.add_child(_player)
	
	_player_health_component = _player.get_health_component()


func test_persist_player_health():
	var deal_damage_data = DealDamageData.new()
	deal_damage_data.damage = 5.0
	deal_damage_data.caster = _player
	
	_player_health_component.deal_damage(deal_damage_data)
	
	assert_eq(_player_health_component.current_health, 95.0)
	
	_player.free()
	
	_create_player()
	
	assert_eq(_player_health_component.current_health, 95.0)
