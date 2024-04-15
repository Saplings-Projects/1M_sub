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
