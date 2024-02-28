class_name TestMapBase extends GutTest

var test_width: Array[int] = [1,3,5,3,1]

var test_map: MapBase = null

func before_each() -> void:
	MapManager.map_width_array = test_width 
	# need to change the manager since it's globally loaded
	test_map = MapManager.create_map()
	MapManager.current_map = test_map
	
	
func after_each() -> void:
	assert_no_new_orphans("There are orphans left in the test, please free resources")
