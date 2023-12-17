extends CardMovementState
class_name MoveState_InHand


# @Override
func on_state_process(delta: float) -> void:
	_state.card.position = _state.card.position.lerp(_state.desired_position, delta * 4.0)
