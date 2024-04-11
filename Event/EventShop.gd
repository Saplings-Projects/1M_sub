extends EventBase
class_name EventShop

# @Override
func _init() -> void:
	pass
	
# @Override
func _update_event() -> void:
	print("Updating shop")

# @Override
func get_room_abbreviation() -> String:
	return "S"
	
## @Override
func check_event_end_condition() -> bool:
	# You can leave the shop as soon as you enter it
	return true
