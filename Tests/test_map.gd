extends GutTest



func test_map_gen():
	var test_generator = load("res://Map/MapManager.gd")
	var test_floor:Floor = Floor.new()
	var result = test_generator.generate_rooms(test_floor)
	assert_eq(result, test_floor, "Generator should return floor class")
	pass
