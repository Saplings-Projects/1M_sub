extends Node2D
## Class to manage backend for rooms (generation and such)

signal populate_floor ## call this to generate rooms in a floor
signal populated_floor ## fires when a floor has rooms generated in it
@export var mob_chance:int = 10
@export var max_mob_spawns:int = 5



static func generate_rooms(_floor:Floor): ## Populates a floor with rooms that have random room types.
	var _grid = [] ## 2d array to return. this will be populated with rooms
	for i in _floor.room_array_width: ## construct 2d array to return
		_grid.append([])
		for j in _floor.room_array_height:
			_grid[i].append(0)

	for x in range(_floor.room_array_width): ## loop through elements of the grid and assign a room type
		for y in range(_floor.room_array_height):
			var _generated_room:Room = Room.new()
			var _possible_room_types = _generated_room.RoomType
			var rand_type = _possible_room_types.keys()[randi() % _possible_room_types.size()]
			_grid[x][y] = rand_type
			_generated_room.coordinates = Vector2(x,y)
	return _floor
	
