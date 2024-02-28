extends Resource
class_name RoomBase
## Class for a room on the map. Provides base classes for all rooms to use regardless of the type
##
## Holds basic functionality for a room on the map

@export var light_data: LightData
@export var room_event: EventBase
var room_position: Vector2i

func _init() -> void:
	light_data = LightData.new()

func _to_string() -> String:
	return "RoomBase"

func get_room_abbreviation() -> String:
	return room_event.get_room_abbreviation()

func set_torch_active() -> void:
	light_data.has_torch = true
	light_data.increase_light_by_torch()
