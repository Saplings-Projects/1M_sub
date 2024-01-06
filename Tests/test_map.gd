extends GutTest ## Tests for MapManager, more will be added in the future

var test_generator = load("res://Map/MapManager.gd")

func test_map_gen():
	var test_width: Array[int] = [1,3,5,3,1]
	var test_map: MapBase = test_generator.create_map(test_width)
	var expected_null_array: Array[Array] = [[0,0], [0,1], [0,3],[0,4],[1,0],[1,4],[3,0],[3,4],[4,0],[4,1],[4,3],[4,4]]
	var expected_exists_array: Array[Array] = [[0,2],[1,1],[1,2],[1,3],[2,0],[2,1],[2,2],[2,3],[2,4],[3,1],[3,2],[3,3],[4,2]]
	for couple: Array[int] in expected_null_array:
		assert_null(test_map.rooms[couple[0]][couple[1]], "expected null at"+str(couple))
		
	for couple: Array[int] in expected_exists_array:
		assert_not_null(test_map.rooms[couple[0]][couple[1]], "expected not null at"+str(couple))
