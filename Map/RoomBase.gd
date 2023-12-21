extends Resource
class_name RoomBase
## Class for a room on the map. Provides base classes for all rooms to use regardless of the type
##
## Holds basic functionality for a room on the map

enum RoomEvent
{
	MONSTER,
	HEAL,
	SHOP,
}

@export var light_level: int = 0
@export var has_torch: bool = false
@export var this_room_event: RoomEvent
@export var coordinates: Vector2
