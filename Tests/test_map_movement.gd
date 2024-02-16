extends TestMapBase

func test_accessible_positions_by_player() -> void:
	var player_position_array: Array[Vector2i] = [
		Vector2i(2,4), 
		Vector2i(4,2),
		Vector2i(0,2),
		Vector2i(1,2),
		Vector2i(2,0)
	]
	var expected_accessible_positions: Array[Array] = [
		[Vector2i(1,3), Vector2i(2,3), Vector2i(3,3)],
		[Vector2i(3,1)],
		[Vector2i(1,1)],
		[Vector2i(1,1), Vector2i(2,1)],
		[]
	]
	for i: int in range(player_position_array.size()):
		var current_player_position: Vector2i = player_position_array[i]
		assert_not_null(MapManager.current_map.rooms[current_player_position.y][current_player_position.x])
		var accessible_positions: Array[Vector2i]  = MapMovement.get_accessible_room_positions_by_player(current_player_position)
		for position: Vector2i in expected_accessible_positions[i]:
			assert_has(accessible_positions,position)
