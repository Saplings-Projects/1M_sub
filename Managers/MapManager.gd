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

## Checks if the current room event upholds all map generation rules
func is_room_event_correct(current_room: RoomBase, map: MapBase = current_map) -> bool:
	## Rule 0: A room cannot have no event
	if current_room.room_event == null:
		return false
	
	var current_room_event_name: String = current_room.room_event.get_event_name()

	## Rule 1: No Heal room before half of the map
	if current_room_event_name == "heal" && current_room.room_position.y < int(map.rooms.size()/2.0):
		return false


	## Rule 2: Cannot have 2 consecutive Heal or Shop rooms
	# Room events that we do not want to be consecutive
	const no_consecutive_room_event: Array[String] = ["shop", "heal"]
	
	# We need to check the parents if current room event is shop or heal
	if current_room_event_name in no_consecutive_room_event:
		# Get the parent rooms' types
		var _parent_events: Array[String] = []
		for delta_x: int in [-1, 0, 1]:
			var _parent_x: int = current_room.room_position.x + delta_x
			var _parent_y: int = current_room.room_position.y - 1
			if _parent_y >= 0 && _parent_x >= 0 && _parent_x < map.rooms[_parent_y].size() && map.rooms[_parent_y][_parent_x] != null:
				_parent_events.append(map.rooms[_parent_y][_parent_x].room_event.get_event_name())

		# Check if current room has the same type as one of its parent room
		if current_room_event_name in _parent_events:
			return false


	## Rule 3: There must be at least 2 room types among destinations of Rooms that have 2 or more Paths going out. [br]
	## Since the events of the rooms on the right of current room ((x+i,y), i=1,2,...) have not been generated yet, [br]
	## we don't need to take them into account. We only check neighbors on the left: (x-2,y), (x-1,y) and (x,y) [br]
	## Note: We make sure the two leftmost and rightmost rooms of the floor have different events, [br]
	## since they could be the only destinations of a room from the previous floor (happens when current floor's size [br]
	## is smaller or equal than previous)
	var _neighbors_events: Array[String] = []
	var delta_xs: Array[int] = []

	# If rightmost room of floor
	if current_room.room_position.x == map.rooms[current_room.room_position.y].size() - 1 or map.rooms[current_room.room_position.y][current_room.room_position.x+1] == null:
		delta_xs = [-1, 0]
	else:
		delta_xs = [-2, -1, 0]
		
	# Get the neighbor and current rooms types
	for delta_x: int in delta_xs:
		var _neighbor_x: int = current_room.room_position.x + delta_x
		var _neighbor_y: int = current_room.room_position.y
		if _neighbor_x >= 0 && _neighbor_x < map.rooms[_neighbor_y].size() && map.rooms[_neighbor_y][_neighbor_x] != null:
			_neighbors_events.append(map.rooms[_neighbor_y][_neighbor_x].room_event.get_event_name())

	# If our current room has no neighbors on the left, ignore this rule
	if _neighbors_events.size() >= 2:
		var _unique: Array[String] = []

		# Remove duplicates
		for event in _neighbors_events:
			if not _unique.has(event):
				_unique.append(event)
		
		# If there is only one event type among all rooms, redraw event
		if _unique.size() == 1:
			return false


	## Rule 4: No Heal rooms two floors before Boss
	if (current_room_event_name == "heal" && current_room.room_position.y == map.rooms.size() - 3):
		return false

	return true


## Draws room type randomly, with each type having a set probability [br]
## Algorithm taken from this: https://stackoverflow.com/a/1761646
func draw_room_type() -> EventBase:
	var _total_proba: int = 0
	for event: GlobalEnums.EventType in GlobalVar.EVENTS_PROBABILITIES:
		# print(event)
		_total_proba += GlobalVar.EVENTS_PROBABILITIES[event]

	var _rand_type_number: int = randi_range(0, _total_proba-1)

	for _rand_type_index: GlobalEnums.EventType in GlobalVar.EVENTS_PROBABILITIES:
		if _rand_type_number < GlobalVar.EVENTS_PROBABILITIES[_rand_type_index]:
			return GlobalVar.EVENTS_CLASSIFICATION[_rand_type_index].new()

		_rand_type_number -= GlobalVar.EVENTS_PROBABILITIES[_rand_type_index]
	
	# This shouldn't be reached
	return null

## Assign events to existing rooms with set probabilities.
func assign_events(map: MapBase = current_map) -> void:
	# Scan the whole map, assign events to valid rooms
	for index_height: int in range(map.rooms.size()):
		for index_width: int in range(map.rooms[index_height].size()):
			# If not a room, ignore
			if map.rooms[index_height][index_width] == null:
				continue
			
			var _current_room: RoomBase = map.rooms[index_height][index_width]

			# Set fixed rooms here
			if index_height == map.rooms.size() - 2:
				# Rooms before boss are Heal rooms
				_current_room.room_event = EventHeal.new()

			elif index_height == map.rooms.size() - 1:
				# Boss room, TO BE ASSIGNED
				_current_room.room_event = EventMob.new()

			else:
				while not is_room_event_correct(_current_room, map):
					_current_room.room_event = draw_room_type()

## Create a map with a width array

func _ready() -> void:
	if not is_map_initialized():
		map_width_array = [1, 3, 5, 7, 9, 11, 9, 7, 5, 3, 1]
		current_map = create_map()


		##### DEBUG #####
		# Count number of each event
		if DebugVar.DEBUG_PRINT_EVENT_COUNT:
			var events: Dictionary = {}
			var total_nb_rooms: int = 0
			var expected_probabilities: Dictionary = {"mob": 45, "random": 16, "heal": 12, "dialogue": 22, "shop": 5}
			
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
				print("Event " + k + " has "+ str(events[k]) + " rooms. (is " + str(float(events[k])*100/total_nb_rooms).pad_decimals(2) + "%, expected: " + str(expected_probabilities[k]) + "%)")
			print("Total number of rooms generated: " + str(total_nb_rooms))

## checks if the map exists

func is_map_initialized() -> bool:
	return current_map != null
