extends EventBase
class_name EventShop
## Buy cards, consumables and other stuff in this event

## @Override [br]
## See [EventBase] for more information [br]
func _init() -> void:
	pass
	
## @Override [br]
## See [EventBase] for more information [br]
func _update_event() -> void:
	print("Updating shop")

## @Override [br]
## See [EventBase] for more information [br]
func get_room_abbreviation() -> String:
	return "S"

	
## @Override	
## The name used to identify the event in the filesystem (scenes and such)
func get_event_name() -> String:
	return "shop"
	
## @Override
func check_event_end_condition() -> bool:
	# You can leave the shop as soon as you enter it
	return true
