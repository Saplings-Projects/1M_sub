extends Node2D
class_name LerpComponent
## Simple component that smoothly moves its parent towards a desired position.


@export var lerp_speed: float = 4.0

var desired_position: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	get_parent().position = get_parent().position.lerp(desired_position, delta * lerp_speed)
