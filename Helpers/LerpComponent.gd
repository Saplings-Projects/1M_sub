extends Node2D
class_name LerpComponent
## Simple component that smoothly moves its parent towards a desired position.


## The speed at which the parent moves towards the desired position.
@export var lerp_speed: float = 4.0

## The desired position the parent should move towards.
var desired_position: Vector2 = Vector2.ZERO


## Move by [param delta] * [param lerp speed] every frame towards [param desired_position].
func _process(delta: float) -> void:
	get_parent().position = get_parent().position.lerp(desired_position, delta * lerp_speed)
