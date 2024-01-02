extends Resource
class_name MapBase
## Class for the map. Provides functions for the map
##
## Holds basic functionality for a map

@export var rooms: Array[Array] = [] ## 2D array of rooms on the map. this will be assigned when generating rooms
@export var floors_width: Array[int] = [1, 3, 5, 7, 5, 3, 1] ## array for variable map width, each element is the width of a floor
