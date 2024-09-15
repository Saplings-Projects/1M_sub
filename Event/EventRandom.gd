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

## Randomly select another event
static func choose_other_event() -> EventBase:
	# Choose an index
	# This assumes the random event is the element 0 of the enum, meaning we don't select it
	return GlobalEnums.choose_event_from_type(randi_range(1, GlobalEnums.EventType.size() - 1))
	
	
## @Override	
## The name used to identify the event in the filesystem (scenes and such)
func get_event_name() -> String:
	return "random"
	
