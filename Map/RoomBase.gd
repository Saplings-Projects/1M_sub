extends Resource
class_name Room
## Class for a room on the map. Provides base classes for all rooms to use regardless of the type
##
## Holds basic functionality for a room on the map
@export var light_level: int = 0
@export var has_torch: bool = false

func get_room_type():
	pass ## Add to this later, when room types are assigned

