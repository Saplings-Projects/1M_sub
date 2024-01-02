extends GutTest ## Tests for MapManager, more will be added in the future

var test_generator = load("res://Map/MapManager.gd")



func test_map_gen():
	var test_width: Array[int] = [1,3,5,3,1]
	var test_map: MapBase = test_generator.create_map(test_width)
	assert_null(test_map.rooms[0][0])
	assert_null(test_map.rooms[0][1])
	assert_null(test_map.rooms[0][3])
	assert_null(test_map.rooms[0][4])
	assert_null(test_map.rooms[4][0])
	assert_null(test_map.rooms[4][1])
	assert_null(test_map.rooms[4][3])
	assert_null(test_map.rooms[4][4])
	assert_null(test_map.rooms[1][0])
	assert_null(test_map.rooms[1][4])
	assert_null(test_map.rooms[3][0])
	assert_null(test_map.rooms[3][4])
