extends Node2D
## Class to manage backend for rooms (generation and such)

static func generate_rooms(_map:MapBase): ## Populates a map with rooms that have random room types. More in depth algorithms will be added later
	var _grid = [] ## 2d array to return. this will be populated with rooms
	for i in _map.width: ## construct 2d array to return
		_grid.append([])
		for j in _map.height:
			_grid[i].append(0)

	for x in range(_map.width): ## loop through elements of the grid and assign a room type
		for y in range(_map.height):
			var _generated_room: RoomBase = RoomBase.new()
			var _rand_type: String = _generated_room.RoomEvent.keys()[randi() % _generated_room.RoomEvent.size()]
			var _rand_type_index: int = _generated_room.RoomEvent.get(_rand_type)
			_grid[x][y] = _rand_type
			_generated_room.coordinates = Vector2(x,y)
			#print("Generated room at: " + str(_generated_room.coordinates) + " with event " + str(_rand_type) + ", Map size: " + str(Vector2(_map.width, _map.height)))
	_map.rooms = _grid
	#print(_map.rooms)
	return _map
