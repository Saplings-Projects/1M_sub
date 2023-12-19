extends GutTest ## Tests for MapManager

var test_generator = load("res://Map/MapManager.gd")

var test_floor:Floor = Floor.new()

func test_map_gen():
	
	var result = test_generator.generate_rooms(test_floor)
	assert_eq(result, test_floor, "Generator should return floor class")
	pass
