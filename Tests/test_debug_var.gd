extends GutTest
## Ensure all debug var are set to false
##
## Ensures that all the DEBUG variables (which let you do stuff you are not supposed to, for testing purposes) are set to false. [br]
## This prevents us from accidentally leaving them on and potentially building a release with them on.
func test_all_DEBUG_false() -> void:
	var list_of_debug: Dictionary = DebugVar.get_script().get_script_constant_map()
	print(list_of_debug)
	for debug_var: bool in list_of_debug.values():
		assert_false(debug_var)
