extends Resource
class_name RoomBase
## Class for a room on the map. Provides base classes for all rooms to use regardless of the type
##
## Holds basic functionality for a room on the map

@export var possible_events: Array = [EventHeal, EventMob, EventRandom, EventShop]
@export var light_level: int = 0
@export var has_torch: bool = false
@export var this_room_event: EventBase
