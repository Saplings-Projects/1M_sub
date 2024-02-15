class_name MapMovement extends Resource


static func get_accessible_room_positions_by_player(position: Vector2i) -> Array[Vector2i]:
	var accessible_room_positions: Array[Vector2i] = []
	var map_width_array: Array[int] = MapManager.map_width_array
	for movement: Vector2i in GlobalVar.POSSIBLE_MOVEMENTS:
		var new_floor_index: int = position.y + movement.y
		var new_room_index: int = position.x + movement.x
		if new_floor_index >= 0 and new_floor_index <= map_width_array.size() - 1:
			if new_room_index >= 0 and new_room_index <= map_width_array[new_floor_index] - 1:
				var room: RoomBase = MapManager.current_map.rooms[new_floor_index][new_room_index]
				# assuming all maps whatever the type are based on the same width array
				if room != null:
					accessible_room_positions.append(Vector2i(new_room_index, new_floor_index))
	
	return accessible_room_positions
	
static func get_all_accessible_room_positions_in_range(position: Vector2i, remaining_range: int) -> Array[Vector2i]:
	var accessible_room_positions_in_range: Array[Vector2i] = []
	var accessible_room_positions_by_player: Array[Vector2i] = get_accessible_room_positions_by_player(position)
	accessible_room_positions_in_range.append_array(accessible_room_positions_by_player)
	if remaining_range == 1:
		return Helpers.remove_duplicate_in_array(accessible_room_positions_in_range)
		
	for next_position: Vector2i in accessible_room_positions_by_player:
		accessible_room_positions_in_range.append_array(get_all_accessible_room_positions_in_range(next_position, remaining_range - 1))
	
	return Helpers.remove_duplicate_in_array(accessible_room_positions_in_range)
	
