extends TestMapBase

func _check_accessible_rooms(
	player_position_array: Array[Vector2i], 
	expected_accessible_positions: Array[Array], 
	func_to_test: Callable, 
	other_args: Array
	) -> void:
	for i: int in range(player_position_array.size()):
		var current_player_position: Vector2i = player_position_array[i]
		assert_not_null(MapManager.current_map.rooms[current_player_position.y][current_player_position.x])
		var all_args: Array = [current_player_position]
		all_args.append_array(other_args)
		var accessible_positions: Array[Vector2i] = func_to_test.callv(all_args)
		for position: Vector2i in expected_accessible_positions[i]:
			assert_has(accessible_positions,position)
			accessible_positions.erase(position)
		assert_eq(accessible_positions,[])
	


func test_accessible_positions_by_player() -> void:
	var player_position_array: Array[Vector2i] = [
		Vector2i(2,0), 
		Vector2i(4,2),
		Vector2i(0,2),
		Vector2i(1,2),
		Vector2i(2,4)
	]
	var expected_accessible_positions: Array[Array] = [
		[Vector2i(1,1), Vector2i(2,1), Vector2i(3,1)],
		[Vector2i(3,3)],
		[Vector2i(1,3)],
		[Vector2i(1,3), Vector2i(2,3)],
		[]
	]
	var callable_to_test: Callable = Callable(MapMovement, "get_accessible_room_positions_by_player")
	_check_accessible_rooms(player_position_array, expected_accessible_positions, callable_to_test, [])


func test_accessible_positions_by_player_in_range() -> void:
	var player_position_array: Array[Vector2i] = [
		Vector2i(2,0), 
		Vector2i(4,2),
		Vector2i(0,2),
		Vector2i(1,2),
		Vector2i(2,4)
	]
	var expected_accessible_positions: Array[Array] = [
		[
			Vector2i(1,1), Vector2i(2,1), Vector2i(3,1), 
			Vector2i(0,2), Vector2i(1,2), Vector2i(2,2), 
			Vector2i(3,2), Vector2i(4,2)
		],
		[Vector2i(3,3), Vector2i(2,4)],
		[Vector2i(1,3), Vector2i(2,4)],
		[Vector2i(1,3), Vector2i(2,3), Vector2i(2,4)],
		[]
	]
	var callable_to_test: Callable = Callable(MapMovement, "get_all_accessible_room_positions_in_range")
	var remaining_range: int = 2 # 3 usually but it's a lot of rooms to write
	_check_accessible_rooms(player_position_array, expected_accessible_positions, callable_to_test, [remaining_range])
