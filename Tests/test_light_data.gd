extends GutTest
## Test the LightData class
##
## This checks that the light level in rooms works as expected

var light_data: LightData

func before_each() -> void:
	light_data = LightData.new()


func test_increase_light_level_by_movement_initialized() -> void:
	light_data.increase_light_by_player_movement()
	
	assert_eq(light_data.light_level, GlobalEnums.LightLevel.DIMLY_LIT, "Light Level should be Dimly Lit when is Unlit and navigating by room")

func test_increase_light_level_by_movement_changed_light_level() -> void:
	light_data.light_level = GlobalEnums.LightLevel.DIMLY_LIT
	
	light_data.increase_light_by_player_movement()
	assert_eq(light_data.light_level, GlobalEnums.LightLevel.DIMLY_LIT, "Light level should not be changing if it is already has some level of light and we navigate by room")
	
	light_data.light_level = GlobalEnums.LightLevel.LIT
	
	light_data.increase_light_by_player_movement()
	assert_eq(light_data.light_level, GlobalEnums.LightLevel.LIT, "Light level should not be changing if it is already has some level of light and we navigate by room")
	
	light_data.light_level = GlobalEnums.LightLevel.BRIGHTLY_LIT
	assert_eq(light_data.light_level, GlobalEnums.LightLevel.BRIGHTLY_LIT, "Light level should not be changing if it is already has some level of light and we navigate by room")

func test_increase_light_level_by_torch_initialized() -> void:
	light_data.has_torch = true
	light_data.increase_light_by_torch()
	
	assert_eq(light_data.light_level, GlobalEnums.LightLevel.LIT, "Light level should be lit when a torch is placed down")
	
func test_increase_light_level_by_torch_different_light_levels() -> void:
	light_data.has_torch = false
	light_data.light_level = GlobalEnums.LightLevel.DIMLY_LIT
	light_data.increase_light_by_torch()
	
	assert_eq(light_data.light_level, GlobalEnums.LightLevel.LIT, "Light level should be lit when function is called and level is dimly lit")
	
	light_data.light_level = GlobalEnums.LightLevel.LIT
	light_data.increase_light_by_torch()
	
	assert_eq(light_data.light_level, GlobalEnums.LightLevel.BRIGHTLY_LIT, "Light level should be brightly lit when function is called and level is lit")
	
	light_data.light_level = GlobalEnums.LightLevel.BRIGHTLY_LIT
	light_data.increase_light_by_torch()
	
	assert_eq(light_data.light_level, GlobalEnums.LightLevel.BRIGHTLY_LIT, "Light level shouldn't change if it's already brightly lit")
