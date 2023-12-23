extends GutTest ## Tests for MapManager, more will be added in the future

var test_generator = load("res://Map/MapManager.gd")

func test_map_gen():
	var result = test_generator.create_map()
	assert_eq(result, result, "Expected to return generated class")
