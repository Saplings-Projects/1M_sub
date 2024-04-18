extends EventBase
class_name EventRandom
## A random event
##
## This will randomly select one of the other possible event

## @Override [br]
## See [EventBase] for more information [br]
func _init() -> void:
	pass
	
## @Override [br]
## See [EventBase] for more information [br]
func _update_event() -> void:
	print("Updating Random Event")

## @Override [br]
## See [EventBase] for more information [br]
func get_room_abbreviation() -> String:
	return "R"
