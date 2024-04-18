extends Resource
class_name RoomBase
## Class for a room on the map. Provides base classes for all rooms to use regardless of the type
##
## Holds basic functionality for a room on the map

## Information about the level of light in a room
@export var light_data: LightData
## The event in the room (see [EventBase])
@export var room_event: EventBase
## The position of the room on the map [br]
## The first floor is at index 0 [br]
## Rooms are indexed by their distance to the map border, so the first room of the first floor could be in position [2,0] [br]
## See [MapMovement] for more information [br]
var room_position: Vector2i

## Init the light data [br]
func _init() -> void:
	light_data = LightData.new()

## Wrapper around [method RoomEvent.get_room_abbreviation]
func get_room_abbreviation() -> String:
	return room_event.get_room_abbreviation()

## Put a torch in the given room and light up the rooms that are in the range of the torch
func set_torch_active() -> void:
	light_data.has_torch = true
	light_data.increase_light_by_torch()
