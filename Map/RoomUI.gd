extends Control
class_name RoomUI

var room: RoomBase
@export var label: Label
@export var button: TextureButton


func _ready():
	button.pressed.connect(_set_player_position_based_on_room)

var floor_index: int = 0
var room_index: int = 0

func set_label(title: String) -> void:
	label.set_text(title)

func get_light_level() -> Enums.LightLevel:
	return room.light_level

func has_torch() -> bool:
	return room.has_torch

func get_center_X() -> float:
	return position.x + button.get_size().x / 2
	
func get_center_Y() -> float:
	return position.y + button.get_size().y / 2
	
func get_room_rect() -> Rect2:
	return Rect2(position.x, position.y, button.get_size().x, button.get_size().y)

func get_center_point() -> Vector2:
	return Vector2(get_center_X(), get_center_Y())
	
func _set_player_position_based_on_room():
	PlayerManager.player_position = room.room_position
	SignalBus.clicked_next_room_on_map.emit(self)

func get_room_rect_packed_array() -> PackedVector2Array:
	var packed_array: PackedVector2Array
	packed_array.append(Vector2(position.x, position.y))
	packed_array.append(Vector2(position.x, position.y + button.get_size().y))
	packed_array.append(Vector2(position.x + button.get_size().x, position.y + button.get_size().y))
	packed_array.append(Vector2(position.x + button.get_size().x, position.y))
	return packed_array
