extends EventBase
class_name EventMob
## Fight event
##
##

## @Override [br]
## See [EventBase] for more information [br]
func _init() -> void:
	pass
	
## @Override [br]
## See [EventBase] for more information [br]
func _update_event() -> void:
	print("Update Mob")

## @Override [br]
## See [EventBase] for more information [br]
func get_room_abbreviation() -> String:
	return "M"
