extends EventBase
class_name EventMob

# ? Should the list of mobs be stored in the event

# For later
# var reward: Item = None

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
## The name used to identify the event in the filesystem (scenes and such)
func get_event_name() -> String:
	return "mob"
	
## @Override
func on_event_started() -> void:
	super()
	# TODO spawn mobs
	
## @Override
func on_event_ended() -> void:
	super()
	# TODO show reward screen
	