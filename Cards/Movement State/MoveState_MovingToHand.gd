extends CardMovementState
class_name MoveState_MovingToHand
 ## MovingToHand state. Scales to 1 from 0 and sets to desired position


const MOVE_SPEED: float = 15.0
const EASE_TIME: float = 0.5
const EASE_TYPE: Tween.EaseType = Tween.EASE_OUT
const TRANS_TYPE: Tween.TransitionType = Tween.TRANS_CUBIC


# @Override
func on_state_enter() -> void:
	# Scale up from zero
	# When finished, set state to IN_HAND
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.SCALE_PROPERTY, Vector2.ONE, EASE_TIME)\
	.set_ease(EASE_TYPE)\
	.set_trans(TRANS_TYPE)\
	.from(Vector2.ZERO)\
	.finished.connect(_on_easing_finished)


# @Override
func on_state_process(delta: float) -> void:
	# Ease to desired position in the hand
	_state.card.position = _state.card.position.lerp(_state.desired_position, delta * MOVE_SPEED)
	
	# Ease rotation
	_state.card.rotation_degrees = lerpf(_state.card.rotation_degrees, _state.desired_rotation, delta * MOVE_SPEED)


func _on_easing_finished() -> void:
	# Fire off this signal, which should exit this state and enter the IN_HAND state
	trigger_exit_state.emit(GlobalEnum.CardMovementState.IN_HAND)
