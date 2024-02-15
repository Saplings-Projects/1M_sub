class_name MapMovement extends Resource


static func get_all_accessible_rooms(floor_index: int, room_index: int) -> Array[RoomBase]:
	var accessible_rooms: Array[RoomBase] = []
	var map_width_array: Array[int] = MapManager.map_width_array
	for movement: Vector2 in GlobalVar.POSSIBLE_MOVEMENTS:
		var new_floor_index: int = floor_index + (movement.y as int)
		var new_room_index: int = room_index + (movement.x as int)
		if new_floor_index >= 0 and new_floor_index <= map_width_array.size() - 1:
			if new_room_index >= 0 and new_room_index <= map_width_array[new_floor_index] - 1:
				var room: RoomBase = MapManager.current_map.rooms[new_floor_index][new_room_index]
				if room != null:
					accessible_rooms.append(room)
	
	return accessible_rooms
