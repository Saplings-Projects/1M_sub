extends Node2D
## Class to manage backend for rooms (generation and such)

var current_map: MapBase
var map_width_array: Array[int] = [1, 3, 5, 7, 5, 3, 1]
 
#map_floors_width changes the width of the map's floors
static func create_map(map_floors_width: Array[int]) -> MapBase: ## Generates and Populates a map with rooms that have random room types. More in depth algorithms will be added in the future
	var _map: MapBase = MapBase.new()
	var _grid: Array[Array] = [] ## 2d array to return. this will be populated with rooms
	var _max_floor_size: int = map_floors_width.max()
	for index_height: int in range(map_floors_width.size()): ## loop through the floor and append null to create a square grid
		
		var _floor_width : int = map_floors_width[index_height]
		var _padding_size : int = (_max_floor_size - _floor_width)/2
		
		var _padding:Array = []
		_padding.resize(_padding_size)
		_padding.fill(null)
		_grid.append([])
		_grid[index_height].append_array(_padding)
		
		for index_width: int in range(map_floors_width[index_height]):## loop through elements of the grid and assign a room type
			var _rand_type_index: int = randi_range(0, GlobalVar.EVENTS_CLASSIFICATION.size() - 1)
			var _room_event: EventBase = GlobalVar.EVENTS_CLASSIFICATION[_rand_type_index].new()
			var _generated_room: RoomBase = RoomBase.new()
			_generated_room.room_event = _room_event
			_grid[index_height].append(_generated_room as RoomBase)
		_grid[index_height].append_array(_padding)
	_map.rooms = _grid
	return _map as MapBase
	
func _ready():
	current_map = create_map(map_width_array)
	
func is_map_initialized() -> bool:
	return current_map != null
