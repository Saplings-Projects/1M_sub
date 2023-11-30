extends Label
## Simple setter that pulls from the health component.


@export var health_component : HealthComponent = null


func _ready():
	health_component.on_health_changed.connect(_set_health)
	_set_health(health_component.current_health)


func _set_health(_new_health : float):
	text = str(health_component.current_health) + " / " + str(health_component.max_health)
