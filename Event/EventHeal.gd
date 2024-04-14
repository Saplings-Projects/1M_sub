extends EventBase
class_name EventHeal
## Heal your character in this event
##
## 

## @Override [br]
## See [EventBase] for more information [br]
func _init() -> void:
	pass
	
## @Override [br]
## See [EventBase] for more information [br]
func _update_event() -> void:
	print("Updating Heal Event")

## @Override [br]
## See [EventBase] for more information [br]
func get_room_abbreviation() -> String:
	return "H"
