extends CardMovementState
class_name MoveState_Queued


@export var lerp_speed: float = 10.0
@export var queue_offset: float = -150


# @Override
func on_state_enter() -> void:
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.SCALE_PROPERTY, Vector2(1.3, 1.3), 0.5)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)


# @Override
func on_state_process(delta: float) -> void:
	var offset_desired_position: Vector2 = _state.desired_position
	offset_desired_position.y += queue_offset
	
	_state.card.position = _state.card.position.lerp(offset_desired_position, delta * lerp_speed)
	_state.card.rotation_degrees = lerpf(_state.card.rotation_degrees, 0.0, delta * lerp_speed)
