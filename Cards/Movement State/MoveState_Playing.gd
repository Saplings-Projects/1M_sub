extends CardMovementState
class_name MoveState_Playing
## Playing state. Whenever the card is playing its animations


const MOVE_SPEED: float = 10.0
const EASE_TIME: float = 0.5
const EASE_TYPE: Tween.EaseType = Tween.EASE_OUT
const TRANS_TYPE: Tween.TransitionType = Tween.TRANS_CUBIC
const SCALE_AMOUNT: Vector2 = Vector2(1.3, 1.3)
#Position of card if it's target type
const TARGET_CARD_POS : Vector2 = Vector2(-500, -500)

# @Override
func on_state_enter() -> void:
	# Scale to SCALE_AMOUNT
	_state.card.create_tween()\
	.tween_property(_state.card, EasingConstants.SCALE_PROPERTY, SCALE_AMOUNT, EASE_TIME)\
	.set_ease(EASE_TYPE)\
	.set_trans(TRANS_TYPE)


# @Override
func on_state_process(delta: float) -> void:
	_state.card.position = _state.card.position.lerp(TARGET_CARD_POS, delta * MOVE_SPEED)
	
	# Ease rotation
	_state.card.rotation_degrees = lerpf(_state.card.rotation_degrees, 0.0, delta * MOVE_SPEED)
