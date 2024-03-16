extends Node
class_name CardMovementComponent
## Holds a mapping of CardMovementState and dispatches state events to them.
##
## To make a new state, derive from CardMovementState. Then add it to the mapping via _state_mapping


signal on_movement_state_update(new_state: GlobalEnums.CardMovementState)

var current_move_state: GlobalEnums.CardMovementState = GlobalEnums.CardMovementState.NONE
# This is meant to be updated by CardContainer. This property Resource is sent to the state when
# it is initialized, so it will update in the state whenever it is updated in here. 
var state_properties: CardStateProperties = CardStateProperties.new()

# Map each enum to a CardMovementState Resource
var _state_mapping: Dictionary = {
	Enums.CardMovementState.NONE: null,
	Enums.CardMovementState.MOVING_TO_HAND: MoveState_MovingToHand.new(),
	Enums.CardMovementState.IN_HAND: MoveState_InHand.new(),
	Enums.CardMovementState.DISCARDING: MoveState_Discarding.new(),
	Enums.CardMovementState.HOVERED: MoveState_Hovered.new(),
	Enums.CardMovementState.QUEUED: MoveState_Queued.new(),
	Enums.CardMovementState.PLAYING: MoveState_Playing.new(),
}


func _ready() -> void:
	# init state with the parent. Parent should always be a CardWorld
	assert(get_parent() is CardWorld, "Please attach this to a CardWorld!")
	state_properties.card = get_parent()
	
	# bind exit state events
	for state: GlobalEnums.CardMovementState in _state_mapping:
		if _state_not_null(state):
			_state_mapping[state].trigger_exit_state.connect(_on_state_triggered_exit)
	
	set_movement_state(current_move_state)


# @Override
func _process(_delta: float) -> void:
	_on_state_process(current_move_state)


func set_movement_state(new_state: GlobalEnums.CardMovementState) -> void:
	if new_state == current_move_state:
		return
	
	# Check if we can transition from the current state. Exit if not.
	if _state_not_null(current_move_state):
		if not _state_mapping[current_move_state].can_transition_from(new_state):
			return
	
	_on_state_exit(current_move_state)
	
	current_move_state = new_state
	
	_on_state_enter(current_move_state)
	
	on_movement_state_update.emit(current_move_state)


func _on_state_enter(state: GlobalEnums.CardMovementState) -> void:
	if _state_not_null(state):
		# Send the properties to the state and start it
		_state_mapping[state].init_state(state_properties)
		_state_mapping[state].on_state_enter()


func _on_state_process(state: GlobalEnums.CardMovementState) -> void:
	if _state_not_null(state):
		var delta: float = get_process_delta_time()
		_state_mapping[state].on_state_process(delta)


func _on_state_exit(state: GlobalEnums.CardMovementState) -> void:
	if _state_not_null(state):
		_state_mapping[state].on_state_exit()


func _state_not_null(state: GlobalEnums.CardMovementState) -> bool:
	return _state_mapping[state] != null


func _on_state_triggered_exit(state: GlobalEnums.CardMovementState) -> void:
	set_movement_state(state)
