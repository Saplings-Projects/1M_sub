extends EventBase
class_name EventRandom

# @Override
func _init() -> void:
	pass
	
# @Override
func _update_event() -> void:
	print("Updating Random Event")

# @Override
func get_room_abbreviation() -> String:
	return "R"
