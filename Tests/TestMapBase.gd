class_name TestMapBase extends GutTest
## Common test setup for Map related tests

## The width of the different floors [br]
## The map will look as follows (with X being positions not accessible, and O positions are accessible): [br]
## X  X  O  X  X [br]
## X  O  O  O  X [br]
## O  O  O  O  O [br]
## X  O  O  O  X [br]
## X  X  O  X  X [br]
## This is the matrix representation of the map [br]
## The actual map display only shows the O positions [br]
## See [MapMovement] and [MapManager] for more information [br]
var test_width: Array[int] = [1,3,5,3,1]

var test_map: MapBase = null

## Setup the environment before each test [br]
## To be overidden by child tests if they want to do something more or something else [br]
## Child tests that just want to add some stuff can call super to do the initial setup, then their own setup
func before_each() -> void:
	MapManager.map_width_array = test_width 
	# need to change the manager since it's globally loaded
	test_map = MapManager.create_map()
	MapManager.current_map = test_map
	
	
func after_each() -> void:
	# Check that everything has been set free properly [br]
	# This is mainly useful for the CI as some tests can fail silently and the only indication is that resources are not freed
	assert_no_new_orphans("There are orphans left in the test, please free resources")
