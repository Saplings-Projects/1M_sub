extends EventBase
class_name EventMob

# @Override
func _init() -> void:
	pass
	
# @Override
func _update_event() -> void:
	print("Update Mob")

# @Override
func get_room_abbreviation() -> String:
	return "M"
