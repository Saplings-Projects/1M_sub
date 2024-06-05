extends TestBase

## @Override
func before_each() -> void:
	# reset the XpManager since it's not killed between tests (singleton)
	XpManager._ready()
	super()

func test_xp_increase() -> void:
	var current_xp: int = XpManager.current_xp
	var increase_amount: int = 3
	XpManager.increase(increase_amount)
	assert_eq(XpManager.current_xp - current_xp, increase_amount)
	
func test_xp_buff_list() -> void:
	var second_lvl_xp: int = XpManager.xp_levels.keys()[1]
	XpManager.increase(second_lvl_xp)
	var first_two_buffs: Array = XpManager.xp_levels.values().slice(0,2).map(func(tuple: Array) -> BuffBase: return tuple[1])
	assert_eq(first_two_buffs.size(), XpManager.current_list_of_buffs.size())
	for i in range(2):
		assert_true(XpManager.current_list_of_buffs[i].infinite_duration)
		assert_eq(first_two_buffs[i].get_script(), XpManager.current_list_of_buffs[i].get_script())
		
func test_previous_next_level() -> void:
	var xp_lvl: Array = XpManager.xp_levels.keys()
	var third_lvl_xp: int = xp_lvl[2]
	XpManager.increase(third_lvl_xp)
	assert_eq(XpManager.previous_xp_level, third_lvl_xp)
	assert_eq(XpManager.next_xp_level, xp_lvl[3])
