extends Resource
class_name Room
## Class for a room on the map. Provides base classes for all rooms to use regardless of the type
##
## Holds basic functionality for a room on the map

enum RoomType
{
	UNKNOWN,
	MONSTER,
	HEAL,
	SHOP,
}

@export var light_level: int = 0
@export var has_torch: bool = false
@export var this_room_type:RoomType = RoomType.UNKNOWN
@export var coordinates:Vector2
func get_room_type():
	return this_room_type

