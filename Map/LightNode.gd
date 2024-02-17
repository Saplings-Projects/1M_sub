extends Node2D
class_name LightNode

var _color: Color = Color(0, 220, 0, 0)
var _position: Vector2
var _room_ui: RoomUI
var _room_size: Vector2

func _init(position: Vector2, room_ui: RoomUI):
	_position = position
	_room_ui = room_ui
	_room_ui.room.on_light_level_changed.connect(_update_light)
	var new_room_texture_rect: TextureRect = Helpers.get_first_child_node_of_type(_room_ui, TextureRect)
	_room_size = new_room_texture_rect.get_size()

func _draw():
	if _room_ui.get_light_level() == Enums.LightLevel.BRIGHTLY_LIT:
		_color = Color(1, 1, 0, 1)
		draw_rect(Rect2(_room_ui.position, _room_size), _color, false)
	elif _room_ui.get_light_level() == Enums.LightLevel.LIT:
		_color = Color(1, 1, 0, 0.5)
		draw_rect(Rect2(_room_ui.position, _room_size), _color, false)
	elif _room_ui.get_light_level() == Enums.LightLevel.DIMLY_LIT:
		_color = Color(0, 0, 0, 0.5)
		draw_rect(Rect2(_room_ui.position, _room_size), _color)
	else:
		_color = Color(0, 0, 0, 1)
		draw_rect(Rect2(_room_ui.position, _room_size), _color)


func _update_light():
	queue_redraw()
