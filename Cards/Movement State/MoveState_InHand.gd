extends CardMovementState
class_name MoveState_InHand
## InHand state. Moves to desired position


const MOVE_SPEED: float = 10.0
const EASE_TIME: float = 0.5
const EASE_TYPE: Tween.EaseType = Tween.EASE_OUT
const TRANS_TYPE: Tween.TransitionType = Tween.TRANS_CUBIC


# @Override
func on_state_enter() -> void:
	# Ease scale to one. Resets any scale changes that happened in other states (HOVERED, QUEUED)
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.SCALE_PROPERTY, Vector2.ONE, EASE_TIME)\
	.set_ease(EASE_TYPE)\
	.set_trans(TRANS_TYPE)


# @Override
func on_state_process(delta: float) -> void:
	# Ease to desired position in the hand
	_state.card.position = _state.card.position.lerp(_state.desired_position, delta * MOVE_SPEED)
	
	# Ease rotation
	_state.card.rotation_degrees = lerpf(_state.card.rotation_degrees, _state.desired_rotation, delta * MOVE_SPEED)
