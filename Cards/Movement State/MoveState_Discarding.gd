extends CardMovementState
class_name MoveState_Discarding


const EASE_TIME: float = 0.5


# @Override
func on_state_enter() -> void:
	# Move to discard pile
	# Destroy when move is finished
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.GLOBAL_POSITION_PROPERTY, _state.desired_position, EASE_TIME)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)\
	.finished.connect(func(): _state.card.queue_free())
	
	# Scale down to zero
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.SCALE_PROPERTY, Vector2.ZERO, EASE_TIME)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
