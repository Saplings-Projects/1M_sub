extends Resource
class_name RoomBase
## Class for a room on the map. Provides base classes for all rooms to use regardless of the type
##
## Holds basic functionality for a room on the map

@export var light_level: Enums.LightLevel:
	set(value):
		light_level = value
@export var has_torch: bool = false
@export var room_event: EventBase
var room_position: Vector2i

func _init(_light_level: Enums.LightLevel = Enums.LightLevel.UNLIT):
	light_level = _light_level

func _to_string() -> String:
	return "RoomBase"

func get_room_abbreviation() -> String:
	return room_event.get_room_abbreviation()

func set_torch_active() -> void:
	has_torch = true
	if light_level == Enums.LightLevel.LIT:
		light_level = Enums.LightLevel.BRIGHTLY_LIT
	else:
		light_level = Enums.LightLevel.LIT
