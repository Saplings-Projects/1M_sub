extends Resource
class_name LightData

var has_torch: bool
var light_level: Enums.LightLevel

func _init(_light_level: Enums.LightLevel = Enums.LightLevel.UNLIT, _has_torch: bool = false):
	has_torch = _has_torch
	light_level = _light_level

func increase_light_by_torch() -> void:
	if light_level == Enums.LightLevel.LIT:
		light_level = Enums.LightLevel.BRIGHTLY_LIT
	elif light_level < Enums.LightLevel.LIT:
		light_level = Enums.LightLevel.LIT
	
func increase_light_by_room_movement() -> void:
	if light_level == Enums.LightLevel.UNLIT:
		light_level = Enums.LightLevel.DIMLY_LIT
