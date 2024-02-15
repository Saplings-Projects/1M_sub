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
	
