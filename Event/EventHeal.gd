extends EventBase
class_name EventHeal
## Heal your character in this event
##
## 

## @Override [br]
## See [EventBase] for more information [br]
func _init() -> void:
	pass

## @Override	
## The name used to identify the event in the filesystem (scenes and such)
func get_event_name() -> String:
	return "heal"
	
## @Override [br]
## See [EventBase] for more information [br]
func _update_event() -> void:
	print("Updating Heal Event")

## @Override [br]
## See [EventBase] for more information [br]
func get_room_abbreviation() -> String:
	return "H"

## @Override
func on_event_ended() -> void:
	super()
	print("Heal event ended")
