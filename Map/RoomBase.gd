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
	if room_event is EventHeal:
		return "H"
	elif room_event is EventMob:
		return "M"
	elif room_event is EventRandom:
		return "R"
	elif room_event is EventShop:
		return "S"
	else:
		return ""
