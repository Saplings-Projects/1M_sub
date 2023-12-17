extends CardMovementState
class_name MoveState_Queued


const LERP_SPEED: float = 10.0
const EASE_TIME: float = 0.5
const EASE_TYPE: Tween.EaseType = Tween.EASE_OUT
const TRANS_TYPE: Tween.TransitionType = Tween.TRANS_CUBIC
const QUEUE_OFFSET: float = -100
const SCALE_AMOUNT: Vector2 = Vector2(1.3, 1.3)


# @Override
func on_state_enter() -> void:
	# Scale to SCALE_AMOUNT
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.SCALE_PROPERTY, SCALE_AMOUNT, EASE_TIME)\
	.set_ease(EASE_TYPE)\
	.set_trans(TRANS_TYPE)


# @Override
func on_state_process(delta: float) -> void:
	# Ease position with an offset
	var offset_desired_position: Vector2 = _state.desired_position
	offset_desired_position.y += QUEUE_OFFSET
	
	_state.card.position = _state.card.position.lerp(offset_desired_position, delta * LERP_SPEED)
	
	# Ease rotation
	_state.card.rotation_degrees = lerpf(_state.card.rotation_degrees, 0.0, delta * LERP_SPEED)
