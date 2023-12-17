extends CardMovementState
class_name MoveState_InHand


@export var lerp_speed: float = 10.0


# @Override
func on_state_enter() -> void:
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.SCALE_PROPERTY, Vector2.ONE, 0.5)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)


# @Override
func on_state_process(delta: float) -> void:
	_state.card.position = _state.card.position.lerp(_state.desired_position, delta * lerp_speed)
	_state.card.rotation_degrees = lerpf(_state.card.rotation_degrees, _state.desired_rotation, delta * lerp_speed)
