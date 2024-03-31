extends GutTest

## Ensures that all the DEBUG variables (which let you do stuff you are not supposed to, for testing purposes) are set to false.
## This prevents us from accidentally leaving them on and potentially building a release with them on.
func test_all_DEBUG_false() -> void:
	var list_of_debug: Array[bool] = DebugVar.LIST_OF_DEBUG
	for debug_var: bool in list_of_debug:
		assert_false(debug_var)
