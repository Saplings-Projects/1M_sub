extends EventBase
class_name EventHeal

# @Override
func _init() -> void:
	pass

## @Override	
## The name used to identify the event in the filesystem (scenes and such)
func get_event_name() -> String:
	return "heal"
	
# @Override
func _update_event() -> void:
	print("Updating Heal Event")

# @Override
func get_room_abbreviation() -> String:
	return "H"
