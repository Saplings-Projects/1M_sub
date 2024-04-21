extends Control
class_name RoomUI
## Holds the information about the visual of the room on the map display

## The actual room object
var room: RoomBase
## The text to display for the room
@export var label: Label
## The button linked to the room on the map
@export var button: TextureButton


func _ready() -> void:
	button.pressed.connect(_set_player_position_based_on_room)

var floor_index: int = 0
var room_index: int = 0

func set_label(title: String) -> void:
	label.set_text(title)

func get_light_level() -> GlobalEnums.LightLevel:
	return room.light_data.light_level

func has_torch() -> bool:
	return room.light_data.has_torch

func get_center_X() -> float:
	return position.x + button.get_size().x / 2
	
func get_center_Y() -> float:
	return position.y + button.get_size().y / 2
	
func get_room_rect() -> Rect2:
	return Rect2(position.x, position.y, button.get_size().x, button.get_size().y)

func get_center_point() -> Vector2:
	return Vector2(get_center_X(), get_center_Y())
	
## Change the player position to match the position of the room he is in, load the scene related to the room if [param switch_scene] is true
func _set_player_position_based_on_room(switch_scene: bool = true) -> void:
	PlayerManager.player_position = room.room_position
	SignalBus.clicked_next_room_on_map.emit(self, switch_scene)

func get_room_rect_packed_array() -> PackedVector2Array:
	var packed_array: PackedVector2Array = []
	packed_array.append(Vector2(position.x, position.y))
	packed_array.append(Vector2(position.x, position.y + button.get_size().y))
	packed_array.append(Vector2(position.x + button.get_size().x, position.y + button.get_size().y))
	packed_array.append(Vector2(position.x + button.get_size().x, position.y))
	return packed_array
