extends Control
class_name RoomUI

var room: RoomBase
@export var label: Label
@export var texture_rect: TextureRect
@export var player_icon: TextureRect

var floor_index: int = 0
var room_index: int = 0

func set_label(title: String) -> void:
	label.set_text(title)

func toggle_player_icon(enabled: bool) -> void:
	player_icon.visible = enabled
	room.set_light_level(Enums.LightLevel.DIMLY_LIT)

func has_player() -> bool:
	return player_icon.visible

func get_light_level() -> Enums.LightLevel:
	return room.light_level

func get_center_X() -> float:
	return position.x + texture_rect.get_size().x / 2
	
func get_center_Y() -> float:
	return position.y + texture_rect.get_size().y / 2
	
func get_room_rect() -> Rect2:
	return Rect2(position.x, position.y, texture_rect.get_size().x, texture_rect.get_size().y)
