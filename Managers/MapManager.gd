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
var map_width_array: Array[int]
 
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
			# create a new room with the null type and give it its position
			var _generated_room: RoomBase = RoomBase.new()
			_generated_room.room_event = null
			_generated_room.room_position = Vector2i(index_width + _padding_size, index_height)
			# put the new room on the grid
			_grid[index_height].append(_generated_room as RoomBase)
		_grid[index_height].append_array(_padding)
	_map.rooms = _grid

	# Assign room type to all rooms
	assign_events(_map)

	return _map as MapBase

## Draws room type randomly, with each type having a set probability
## Algorithm taken from this: https://stackoverflow.com/a/1761646
func draw_room_type() -> EventBase:
	# Assumes probabilities add up to 100
	var _rand_type_number: int = randi_range(0, 99)

	for _rand_type_index: int in range(GlobalVar.EVENTS_CLASSIFICATION.size()):
		if _rand_type_number < GlobalVar.EVENTS_PROBABILITIES[_rand_type_index]:
			return GlobalVar.EVENTS_CLASSIFICATION[_rand_type_index].new()

		_rand_type_number -= GlobalVar.EVENTS_PROBABILITIES[_rand_type_index]
	
	# This shouldn't be reached
	return null

## Assign events to existing rooms with same probabilities.
func assign_events(current_map: MapBase = current_map) -> void:
	# Scan the whole map, assign events to valid rooms
	for index_height: int in range(current_map.rooms.size()):
		for index_width: int in range(current_map.rooms[index_height].size()):
			# If not a room, ignore
			if current_map.rooms[index_height][index_width] == null:
				continue
			
			var _current_room: RoomBase = current_map.rooms[index_height][index_width]
			_current_room.room_event = draw_room_type()

## Create a map with a width array

func _ready() -> void:
	map_width_array = [1, 3, 5, 7, 9, 11, 9, 7, 5, 3, 1]
	current_map = create_map()


	##### DEBUG #####
	# Count number of each event
	if DebugVar.DEBUG_PRINT_EVENT_COUNT:
		var events: Dictionary = {}
		var total_nb_rooms: int = 0
		for index_height: int in range(current_map.rooms.size()):
			for index_width: int in range(current_map.rooms[index_height].size()):
				if current_map.rooms[index_height][index_width] == null:
					continue
					
				var event: String = current_map.rooms[index_height][index_width].room_event.get_event_name()
				if not event in events:
					events[event] = 0
				events[event] += 1
				total_nb_rooms += 1
		for k:String in events:
			print("Event " + k + " has "+ str(events[k]) + " rooms")
		print("Total number of rooms generated: " + str(total_nb_rooms))

## checks if the map exists

func is_map_initialized() -> bool:
	return current_map != null
