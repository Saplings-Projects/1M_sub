extends Label
## Simple setter that pulls from the stress component.


@export var stress_component: StressComponent = null


func _ready() -> void:
	stress_component.on_stress_changed.connect(_set_stress)
	_set_stress(stress_component.current_stress)


func _set_stress(new_stress: float) -> void:
	if new_stress >= 1:
		text = str(new_stress) + " / " + str(stress_component.max_stress)
	else:
		text = "Soothed"
