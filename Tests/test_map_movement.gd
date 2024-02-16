extends TestMapBase

func test_accessible_positions_by_player() -> void:
	var current_player_position: Vector2i = Vector2i(2, 4) # the room at the bottom of the map
	var accessible_positions: Array[Vector2i] = MapMovement.get_accessible_room_positions_by_player(current_player_position)
	assert_has(accessible_positions, Vector2i(1,3))
	assert_has(accessible_positions, Vector2i(2,3))
	assert_has(accessible_positions, Vector2i(3,3))
