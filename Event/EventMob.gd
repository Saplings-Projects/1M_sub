extends EventBase
class_name EventMob

# ? Should the list of mobs be stored in the event

# @Override
func _init() -> void:
	pass
	
# @Override
func _update_event() -> void:
	print("Update Mob")

# @Override
func get_room_abbreviation() -> String:
	return "M"
	
## @Override
func on_event_started() -> void:
	super()
	# TODO spawn mobs
	
## @Override
func on_event_ended() -> void:
	super()
	# TODO show reward screen
	
## @Override
func check_event_end_condition() -> bool:
	# TODO check if all mobs are dead
	# This might work better if done in the battler
	return false
