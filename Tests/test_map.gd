extends TestMapBase 
## Tests for MapManager, more will be added in the future


func test_map_gen() -> void:
	var expected_null_array: Array[Array] = [[0,0], [0,1], [0,3],[0,4],[1,0],[1,4],[3,0],[3,4],[4,0],[4,1],[4,3],[4,4]]
	var expected_exists_array: Array[Array] = [[0,2],[1,1],[1,2],[1,3],[2,0],[2,1],[2,2],[2,3],[2,4],[3,1],[3,2],[3,3],[4,2]]
	for couple: Array[int] in expected_null_array:
		var _room: RoomBase = test_map.rooms[couple[0]][couple[1]]
		assert_null(_room, "Expected null at %s but got %s" % [couple, _room])

	for couple: Array[int] in expected_exists_array:
		var _room: RoomBase = test_map.rooms[couple[0]][couple[1]]
		assert_not_null(_room, "Expected not null at %s but got %s" % [couple, _room])

## Rule 0: Rooms should not have no event
func test_rule_0_map_gen() -> void:
	var expected_exists_array: Array[Array] = [[0,2],[1,1],[1,2],[1,3],[2,0],[2,1],[2,2],[2,3],[2,4],[3,1],[3,2],[3,3],[4,2]]

	for couple: Array[int] in expected_exists_array:
		var _room_event: EventBase = test_map.rooms[couple[0]][couple[1]].room_event
		assert_not_null(_room_event, "Expected not null event at %s but got %s" % [couple, _room_event])

## Rule 1: No Heal room before half of the map
func test_rule_1_map_gen() -> void:
	var current_room: RoomBase
	for index_height: int in range(int(floor(test_map.rooms.size()/2.0))):
		for index_width: int in range(test_map.rooms[index_height].size()):
			current_room = test_map.rooms[index_height][index_width]
			
			if current_room == null:
				continue
			
			assert_not_same("heal", current_room.room_event.get_event_name(), 
				"Should not have a Heal room before half of the map but found %s at %s" % [current_room.room_event.get_event_name(), current_room.room_position])
				
## Rule 2: No consecutive shop or heal rooms
func test_rule_2_map_gen() -> void:
	var no_consecutive_room_event: Array[String] = ["shop", "heal"]
	var current_room: RoomBase
	
	# Don't care about last floor
	for index_height: int in range(test_map.rooms.size() - 1):
		for index_width: int in range(test_map.rooms[index_height].size()):
			current_room = test_map.rooms[index_height][index_width]
			
			# If current room is not a Heal or Shop room, ignore
			if current_room == null or (not current_room.room_event.get_event_name() in no_consecutive_room_event):
				continue
			print(index_height, " ", index_width)
			
			# Get child room type and compare
			# We define child rooms as rooms that can be reached from our current room
			var child_y: int = current_room.room_position.y + 1
			if child_y >= 0 && child_y < test_map.rooms.size():

				for delta_x: int in [-1, 0, 1]:
					var child_x: int = current_room.room_position.x + delta_x
					if child_x >= 0 && child_x < test_map.rooms[child_y].size() && test_map.rooms[child_y][child_x] != null:
						var consecutive: bool = current_room.room_event.get_event_name() == test_map.rooms[child_y][child_x].room_event.get_event_name()
				
						assert_false(consecutive, "Should not have two consecutive Heal rooms or two consecutive Shop rooms but found %s at %s and %s at %s" % 
									[current_room.room_event.get_event_name(), current_room.room_position, test_map.rooms[child_y][child_x].room_event.get_event_name(), test_map.rooms[child_y][child_x].room_position])


## Rule 3: There must be at least 2 room types among destinations of Rooms that have 2 or more Paths going out.
func test_rule_3_map_gen() -> void:
	var queue : Array[String] = []
	var unique: Array[String] = []
	var current_room: RoomBase
	# Position of the rightmost room of the floor
	var rightmost_room_position: Vector2
	
	# Last floor is Boss room, second last floor is heal rooms
	for index_height: int in range(test_map.rooms.size()-2):
		# Reset queue when new floor
		queue = []
		
		for index_width: int in range(test_map.rooms[index_height].size()):
			while queue.size() >= 3:
				queue.pop_front()
				
			current_room = test_map.rooms[index_height][index_width]
			
			if current_room == null:
				continue
			
			# If current_room is not null, rightmost_room_position is updated
			rightmost_room_position = current_room.room_position
			queue.append(current_room.room_event.get_event_name())

			if queue.size() >= 2:
				unique = []

				# Remove duplicates
				for event in queue:
					if not unique.has(event):
						unique.append(event)
				
				if queue.size() == 2:
					assert_true(unique.size() != 1, "The two leftmost rooms of a floor should not have the same event but found %s at %s and %s at %s " % 
					[test_map.rooms[index_height][index_width-1].room_event.get_event_name(), test_map.rooms[index_height][index_width-1].room_position, 
					 test_map.rooms[index_height][index_width].room_event.get_event_name(), test_map.rooms[index_height][index_width].room_position])

				elif queue.size() == 3:
					assert_true(unique.size() != 1, "3 side by side rooms should not have the same event but found %s at %s, %s at %s and %s at %s " % 
					[test_map.rooms[index_height][index_width-2].room_event.get_event_name(), test_map.rooms[index_height][index_width-2].room_position,
					 test_map.rooms[index_height][index_width-1].room_event.get_event_name(), test_map.rooms[index_height][index_width-1].room_position, 
					 test_map.rooms[index_height][index_width].room_event.get_event_name(), test_map.rooms[index_height][index_width].room_position])

		# Check if the two rightmost rooms of the floor are the same type or not
		queue.pop_front()
		if queue.size() >= 2:
			unique = []

			# Remove duplicates
			for event in queue:
				if not unique.has(event):
					unique.append(event)
			
			assert_true(unique.size() != 1, "The two rightmost rooms of the floor should not have the same event but found %s at %s and %s at %s " % 
					[test_map.rooms[rightmost_room_position.y][rightmost_room_position.x-1].room_event.get_event_name(), test_map.rooms[rightmost_room_position.y][rightmost_room_position.x-1].room_position, 
					 test_map.rooms[rightmost_room_position.y][rightmost_room_position.x].room_event.get_event_name(), test_map.rooms[rightmost_room_position.y][rightmost_room_position.x].room_position])
		

## Rule 4: No heal room two floors before Boss
func test_rule_4_map_gen() -> void:
	var index_no_heal_floor: int = test_map.rooms.size() - 3
	var current_room: RoomBase
	
	for index_width: int in range(test_map.rooms[index_no_heal_floor].size()):
		current_room = test_map.rooms[index_no_heal_floor][index_width]
		
		if current_room == null:
			continue
		
		assert_not_same("heal", current_room.room_event.get_event_name(), 
			"Should not have a Heal room two floors before boss but found %s at %s" % [current_room.room_event.get_event_name(), current_room.room_position])
