extends CardMovementState
class_name MoveState_Discarding


const EASE_TIME: float = 0.5
const EASE_TYPE: Tween.EaseType = Tween.EASE_OUT
const TRANS_TYPE: Tween.TransitionType = Tween.TRANS_CUBIC


# @Override
func on_state_enter() -> void:
	# Move to discard pile
	# Destroy when move is finished
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.GLOBAL_POSITION_PROPERTY, _state.desired_position, EASE_TIME)\
	.set_ease(EASE_TYPE)\
	.set_trans(TRANS_TYPE)\
	.finished.connect(func(): _state.card.queue_free())
	
	# Scale down to zero
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.SCALE_PROPERTY, Vector2.ZERO, EASE_TIME)\
	.set_ease(EASE_TYPE)\
	.set_trans(TRANS_TYPE)


# @Override
func can_transition_from(new_state: Enums.CardMovementState) -> bool:
	# Once you discard, you can't exit this state
	return false
