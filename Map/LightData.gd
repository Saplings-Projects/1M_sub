extends Resource
class_name LightData

var has_torch: bool
var light_level: GlobalEnums.LightLevel

func _init(_light_level: GlobalEnums.LightLevel = GlobalEnums.LightLevel.UNLIT, _has_torch: bool = false) -> void:
	has_torch = _has_torch
	light_level = _light_level

func increase_light_by_torch() -> void:
	if light_level == GlobalEnums.LightLevel.LIT:
		light_level = GlobalEnums.LightLevel.BRIGHTLY_LIT
	elif light_level < GlobalEnums.LightLevel.LIT:
		light_level = GlobalEnums.LightLevel.LIT
	
func increase_light_by_player_movement() -> void:
	if light_level == GlobalEnums.LightLevel.UNLIT:
		light_level = GlobalEnums.LightLevel.DIMLY_LIT
