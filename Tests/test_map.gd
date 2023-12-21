extends GutTest ## Tests for MapManager

var test_generator = load("res://Map/MapManager.gd")

var test_map:MapBase = MapBase.new()

func test_map_gen():
	var result = test_generator.generate_rooms(test_map)
	assert_eq(result, test_map, "Generator should return map class")
	pass
