extends Resource
class_name RoomBase
## Class for a room on the map. Provides base classes for all rooms to use regardless of the type
##
## Holds basic functionality for a room on the map

@export var light_level: int = 0
@export var has_torch: bool = false
@export var room_event: EventBase

func _to_string() -> String:
	return "RoomBase"

func get_room_abbreviation() -> String:
	return room_event.get_room_abbreviation()
