extends Node
class_name CardMovementComponent


signal on_movement_state_update(new_state: Enums.CardMovementState)

var current_move_state: Enums.CardMovementState = Enums.CardMovementState.NONE
var state_properties: CardStateProperties = CardStateProperties.new()

var _state_mapping: Dictionary = {
	Enums.CardMovementState.NONE: null,
	Enums.CardMovementState.MOVING_TO_HAND: MoveState_MovingToHand.new(),
	Enums.CardMovementState.IN_HAND: MoveState_InHand.new(),
	Enums.CardMovementState.DISCARDING: MoveState_Discarding.new(),
	Enums.CardMovementState.HOVERED: MoveState_Hovered.new(),
	Enums.CardMovementState.QUEUED: MoveState_Queued.new(),
}


func _ready():
	# init state with the parent. Parent should always be a CardWorld
	assert(get_parent() is CardWorld, "Please attach this to a CardWorld!")
	state_properties.card = get_parent()
	
	# bind exit state events
	for state in _state_mapping:
		if _has_state(state):
			_state_mapping[state].trigger_exit_state.connect(_on_state_triggered_exit)
	
	set_movement_state(current_move_state)


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
	if _has_state(state):
		_state_mapping[state].init_state(state_properties)
		_state_mapping[state].on_state_enter()


func _on_state_process(state: Enums.CardMovementState):
	if _has_state(state):
		var delta: float = get_process_delta_time()
		_state_mapping[state].on_state_process(delta)


func _on_state_exit(state: Enums.CardMovementState):
	if _has_state(state):
		_state_mapping[state].on_state_exit()


func _has_state(state: Enums.CardMovementState) -> bool:
	return _state_mapping[state] != null


func _on_state_triggered_exit(state: Enums.CardMovementState) -> void:
	set_movement_state(state)
