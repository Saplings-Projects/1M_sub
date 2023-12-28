extends Node2D
## Class to manage backend for rooms (generation and such)
 
static func create_map(): ## Generates and Populates a map with rooms that have random room types. More in depth algorithms will be added in the future
	var _map: MapBase = MapBase.new()
	var _grid: Array = [] ## 2d array to return. this will be populated with rooms
	
	for index_height: int in range(_map.floors_width.size()): ## loop through elements of the grid and assign a room type
		var _max_floor_size = _map.floors_width[_map.floors_width.size()/2]
		_grid.append([])
		var _padding = (_max_floor_size - _map.floors_width[index_height])/2
		var _floor_width = _map.floors_width[index_height]
		for index_padding:int in _padding*2:
			if _padding > 0:
				_grid[index_height].insert(index_padding, null)
		
		for index_width: int in range(_map.floors_width[index_height]):
			var _rand_type_index: int = randi() % GlobalVar.EVENTS_CLASSIFICATION.size()
			var _room_event: EventBase = GlobalVar.EVENTS_CLASSIFICATION[_rand_type_index].new()
			var _generated_room: RoomBase = RoomBase.new()
			_generated_room.room_event = _room_event
			_grid[index_height].insert(index_width+_padding,_generated_room)
	_map.rooms = _grid
	return _map
