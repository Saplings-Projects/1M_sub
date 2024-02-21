class_name MapMovement extends Resource


## Return the list of the accessible positions given the position and the possible movements
## For example, if you have a room UP and UP_LEFT but not UP_RIGHT, this function returns the positions of the room being UP and UP_LEFT of position
static func get_accessible_room_positions_by_given_position(position: Vector2i) -> Array[Vector2i]:
	var map_rooms = MapManager.current_map.rooms
	var map_width_array: Array[int] = MapManager.map_width_array
	var _max_floor_size: int = map_width_array.max()
	var accessible_room_positions: Array[Vector2i] = []
	# if position is out of bounds or current room is null, return empty array
	if (position.y < 0 or position.y > map_rooms.size() - 1) \
		or  position.x < 0 or position.x > _max_floor_size - 1 \
		or map_rooms[position.y][position.x] == null:
		return []
	
	for movement: Vector2i in GlobalVar.POSSIBLE_MOVEMENTS.values():
		var new_floor_index: int = position.y + movement.y
		var new_room_index: int = position.x + movement.x
		if new_floor_index >= 0 and new_floor_index <= map_width_array.size() - 1:
			var _floor_width : int = map_width_array[new_floor_index]
			var _padding_size : int = (_max_floor_size - _floor_width)/2
			if new_room_index >= 0 and new_room_index <= _padding_size + map_width_array[new_floor_index] - 1:
				var room: RoomBase = map_rooms[new_floor_index][new_room_index]
				# assuming all maps whatever the type are based on the same width array
				if room != null:
					accessible_room_positions.append(Vector2i(new_room_index, new_floor_index))
	
	return accessible_room_positions


## Same as get_accessible_room_positions_by_given_position, but it will do as if it was moving in the possible rooms, within a certain range
## Basically if you have a range of 3, it will return the position of all the rooms you can access from position with 3 movements or less
static func get_all_accessible_room_positions_in_range(position: Vector2i, remaining_range: int) -> Array[Vector2i]:
	var accessible_room_positions_in_range: Array[Vector2i] = []
	var accessible_room_positions_by_player: Array[Vector2i] = get_accessible_room_positions_by_given_position(position)
	accessible_room_positions_in_range.append_array(accessible_room_positions_by_player)
	if remaining_range == 1:
		Helpers.remove_duplicate_in_array(accessible_room_positions_in_range)
		return accessible_room_positions_in_range
		
	for next_position: Vector2i in accessible_room_positions_by_player:
		accessible_room_positions_in_range.append_array(get_all_accessible_room_positions_in_range(next_position, remaining_range - 1))
	
	Helpers.remove_duplicate_in_array(accessible_room_positions_in_range)
	return accessible_room_positions_in_range
	

## Return the list of the accessible rooms given the position and the possible movements
## This is different from get_accessible_room_positions_by_given_position because it returns the rooms themselves, not their positions
static func get_all_accessible_rooms_in_range(
	position: Vector2i, 
	remaining_range: int, 
	current_map: Array[Array]
	) -> Array[RoomBase]:
	var accessible_positions_in_range: Array[Vector2i] = get_all_accessible_room_positions_in_range(position, remaining_range)
	var accessible_rooms_in_range: Array[RoomBase] = []
	for current_position: Vector2i in accessible_positions_in_range:
		accessible_rooms_in_range.append(current_map[current_position.y][current_position.x])
	
	return accessible_rooms_in_range


## Helper function to be able to call without any parameters when wanting to do it from the player point of view
static func get_accessible_rooms_by_player(
	position: Vector2i = PlayerManager.player_position, 
	remaining_range: int = 1, 
	current_map: Array[Array] = MapManager.current_map.rooms
	) -> Array[RoomBase]:
	return get_all_accessible_rooms_in_range(position, remaining_range, current_map)
