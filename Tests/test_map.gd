extends GutTest ## Tests for MapManager, more will be added in the future

var test_generator = load("res://Map/MapManager.gd")

func test_map_gen():
	var test_width: Array[int] = [1,3,5,3,1]
	var test_map: MapBase = test_generator.create_map(test_width)
	for index_height in test_map.rooms.size():
		var _padding_loop : int = (5 - test_width[index_height])/2
		var _padding_size : int = (5 + test_width[index_height])/2
		for index_padding in _padding_loop:
			assert_null(test_map.rooms[index_height][index_padding])
			assert_null(test_map.rooms[index_height][index_padding+_padding_size])
