extends Resource
class_name CardMovementState


signal trigger_exit_state(next_state: Enums.CardMovementState)

var _state: CardStateProperties


func init_state(in_state_properties: CardStateProperties) -> void:
	_state = in_state_properties


func on_state_enter() -> void:
	pass


func on_state_process(delta: float) -> void:
	pass


func on_state_exit() -> void:
	pass
