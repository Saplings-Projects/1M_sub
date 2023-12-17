extends CardMovementState
class_name MoveState_MovingToHand


# @Override
func on_state_enter() -> void:
	# Move to hand from draw pile
	# When finished, set state to IN_HAND
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.POSITION_PROPERTY, _state.desired_position, 0.2)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)\
	.finished.connect(func(): trigger_exit_state.emit(Enums.CardMovementState.IN_HAND))
	
	# Scale up from zero
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.SCALE_PROPERTY, Vector2.ONE, 0.2)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)\
	.from(Vector2.ZERO)
