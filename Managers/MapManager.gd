extends Node2D
## Class to manage backend for rooms (generation and such)

##
## With the map width array being [code][1,3,5,3,1][/code], the map looks like that (O are accessible positions, X are null): [br]
## [codeblock]
## X  X  O  X  X
## X  O  O  O  X
## O  O  O  O  O
## X  O  O  O  X
## X  X  O  X  X
## [/codeblock]
## if the map width array is [code][3,3,5,3,1][/code], the map looks like that (O are accessible positions, X are null): [br]
## [codeblock]
## X  X  O  X  X
## X  O  O  O  X
## O  O  O  O  O
## X  O  O  O  X
## X  O  O  O  X

## The map we are on
var current_map: MapBase
## The width of all the map's floors [br]
## Starts with width of first floor
## Width should follow the following rules: [br]
## - Width should be odd (for symmetry + padding reason) [br]
## - Width should not increase or decrease by more than 2 per floor (this makes it certain all rooms on the map are accessible [br]
var map_width_array: Array[int] = [1, 3, 5, 7, 9, 11, 9, 7, 5, 3, 1]
 
#map_floors_width changes the width of the map's floors
## Generates and Populates a map with rooms that have random room types. More in depth algorithms will be added in the future
func create_map(map_floors_width: Array[int] = map_width_array) -> MapBase: 
	var _map: MapBase = MapBase.new()
	# 2d array to return. this will be populated with rooms
	var _grid: Array[Array] = [] 
	var _max_floor_size: int = map_floors_width.max()
	# loop through the floor, add padding, rooms and padding again
	for index_height: int in range(map_floors_width.size()): 
		
		var _floor_width : int = map_floors_width[index_height]
		# ! only works if the size of the floor is odd

		var _padding_size : int = floor((_max_floor_size - _floor_width)/2.)
		
		var _padding:Array = []
		_padding.resize(_padding_size)
		_padding.fill(null)
		_grid.append([])
		_grid[index_height].append_array(_padding)
		

		# loop through positions of the grid and assign a room type
		for index_width: int in range(map_floors_width[index_height]):
			# randomly choose a room type
			var _rand_type_index: int = randi_range(0, GlobalVar.EVENTS_CLASSIFICATION.size() - 1)
			var _room_event: EventBase = GlobalVar.EVENTS_CLASSIFICATION[_rand_type_index].new()
			# create a new room with the room type and give it its position
			var _generated_room: RoomBase = RoomBase.new()
			_generated_room.room_event = _room_event
			_generated_room.room_position = Vector2i(index_width + _padding_size, index_height)
			# put the new room on the grid

			_grid[index_height].append(_generated_room as RoomBase)
		_grid[index_height].append_array(_padding)
	_map.rooms = _grid
	return _map as MapBase


## Create a map with a width array

func _ready() -> void:
	if _has_current_map_saved():
		print("load map data")
		load_map_data()

func _has_current_map_saved() -> bool:
	var save_file: ConfigFile = SaveManager.save_file
	return save_file.has_section_key("MapManager", "current_map")

## checks if the map exists
func is_map_initialized() -> bool:
	return current_map != null

func set_room_light_data(room: RoomBase) -> void:
	current_map.rooms[room.room_position.y][room.room_position.x].light_data = room.light_data

func save_map_data() -> void:
	var save_file: ConfigFile = SaveManager.save_file
	save_file.set_value("MapManager", "map_width_array", map_width_array)
	save_file.set_value("MapManager", "current_map", current_map)
	var error: Error = save_file.save("user://data/save_data.ini")
	if error:
		print("Error saving player data: ", error)

func load_map_data() -> void:
	var save_file: ConfigFile = SaveManager.load_save_file()
	if save_file == null:
		return
	current_map = save_file.get_value("MapManager", "current_map")
	map_width_array = save_file.get_value("MapManager", "map_width_array")

func init_data() -> void:
	current_map = create_map()
