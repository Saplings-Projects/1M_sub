extends TestBase

func test_xp_increase() -> void:
	var current_xp: int = XpManager.current_xp
	var increase_amount: int = 3
	XpManager.increase(increase_amount)
	assert_eq(XpManager.current_xp - current_xp, increase_amount)
	
func test_xp_buff_list() -> void:
	var second_lvl_xp: int = XpManager.xp_levels.keys()[1]
	XpManager.increase(second_lvl_xp)
	var first_two_buffs: Array = XpManager.xp_levels.values().slice(0,2).map(func(tuple: Array) -> BuffBase: return tuple[1])
	assert_eq_deep(XpManager.current_list_of_buffs, first_two_buffs)
