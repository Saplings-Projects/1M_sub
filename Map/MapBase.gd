extends Resource
class_name MapBase
## Class for the map. Provides functions for the map
##
## Holds basic functionality for a map

@export var rooms: Array = [RoomBase] ## 2D array of rooms on the map. this will be assigned when generating rooms
@export var floors_width: PackedInt32Array = [2,3,2] ## array for variable map width, each element is the width of a floor
