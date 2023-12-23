extends Node2D
## Class to manage backend for rooms (generation and such)
 
static func create_map(): ## Generates and Populates a map with rooms that have random room types. More in depth algorithms will be added in the future
	var _map: MapBase = MapBase.new()
	var _grid: Array = [] ## 2d array to return. this will be populated with rooms
	
	for i: int in _map.width.size(): ## construct 2d array to return
		_grid.append([])
		for j: int in _map.width[i]:
			_grid[i].append(0)

	for x: int in range(_map.width.size()): ## loop through elements of the grid and assign a room type
		for y: int in range(_map.width[x]):
			var _generated_room: RoomBase = RoomBase.new()
			var _rand_type_index: int = randi() % _generated_room.possible_events.size()
			var _room_event: EventBase = _generated_room.possible_events[_rand_type_index].new()
			_generated_room.this_room_event = _room_event
			_grid[x][y] = _generated_room
	_map.rooms = _grid
	return _map
