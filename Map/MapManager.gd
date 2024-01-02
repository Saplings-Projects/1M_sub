extends Node2D
## Class to manage backend for rooms (generation and such)
 
#layout changes the width of the map's floors
static func create_map(_layout: Array[int]) -> MapBase: ## Generates and Populates a map with rooms that have random room types. More in depth algorithms will be added in the future
	var _map: MapBase = MapBase.new()
	var _grid: Array[Array] = [] ## 2d array to return. this will be populated with rooms
	var _max_floor_size: int = _layout.max()
	for index_height: int in range(_layout.size()): ## loop through the floor and append null to create a square grid
		_grid.append([])
		
		var _floor_width : int = _layout[index_height]
		var _padding_size : int = (_max_floor_size - _floor_width)/2
		
		_grid[index_height].resize(_max_floor_size-_floor_width)
		_grid[index_height].fill(null)
		
		for index_width: int in range(_layout[index_height]):## loop through elements of the grid and assign a room type
			var _rand_type_index: int = randi() % GlobalVar.EVENTS_CLASSIFICATION.size()
			var _room_event: EventBase = GlobalVar.EVENTS_CLASSIFICATION[_rand_type_index].new()
			var _generated_room: RoomBase = RoomBase.new()
			
			_generated_room.room_event = _room_event
			
			_grid[index_height].insert(index_width+_padding_size,_generated_room as RoomBase)
	#print(_grid)
	_map.rooms = _grid
	return _map as MapBase
