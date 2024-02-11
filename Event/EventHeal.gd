extends EventBase
class_name EventHeal

# @Override
func _init() -> void:
	pass
	
# @Override
func _update_event() -> void:
	print("Updating Heal Event")

# @Override
func get_room_abbreviation() -> String:
	return "H"
