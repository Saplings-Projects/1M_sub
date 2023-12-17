extends Node
class_name CardMovementComponent


signal on_movement_state_update(new_state: Enums.CardMovementState)

@export var lerp_speed: float = 4.0

var current_move_state: Enums.CardMovementState = Enums.CardMovementState.NONE
var desired_position: Vector2 = Vector2.ZERO


func _process(delta):
	_on_state_process(current_move_state)


func set_movement_state(new_state: Enums.CardMovementState):
	if new_state == current_move_state:
		return
	
	_on_state_exit(current_move_state)
	
	current_move_state = new_state
	
	_on_state_enter(current_move_state)
	
	on_movement_state_update.emit(current_move_state)


func _on_state_enter(state: Enums.CardMovementState):
	pass


func _on_state_process(state: Enums.CardMovementState):
	var delta: float = get_process_delta_time()
	get_parent().position = get_parent().position.lerp(desired_position, delta * lerp_speed)


func _on_state_exit(state: Enums.CardMovementState):
	pass

