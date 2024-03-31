extends GutTest

func test_all_DEBUG_false() -> void:
	var list_of_debug: Array[bool] = DebugVar.LIST_OF_DEBUG
	for debug_var: bool in list_of_debug:
		assert_false(debug_var)
