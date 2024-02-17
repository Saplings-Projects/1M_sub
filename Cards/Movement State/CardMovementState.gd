extends Resource
class_name CardMovementState
## Base movement state for a card. Override to create a new movement state.
##
## Each movement state has on_state_enter, on_state_process, and on_state_exit
## on_state_enter - fired when the state first starts. Good for triggering a one time tween.
## on_state_process - fired every frame that the state is active. Good for lerping.
## on_state_exit - fired when the state is finished.
## can_transition_from - If false, then this state will not allow other states
## to trigger from set_movement_state in CardMovementComponent.


# This is meant to be called from child states if you wish to enter another state from within
# that state.
signal trigger_exit_state(next_state: Enums.CardMovementState)

var _state: CardStateProperties


func init_state(in_state_properties: CardStateProperties) -> void:
	_state = in_state_properties


func on_state_enter() -> void:
	pass



func on_state_process(_delta: float) -> void:
	pass


func on_state_exit() -> void:
	pass



func can_transition_from(_new_state: Enums.CardMovementState) -> bool:
	return true
