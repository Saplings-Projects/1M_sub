extends Resource
class_name EventBase


var packedScene: String = ""

# Initialize Event
func _init() -> void:
	pass
	
func _update_event() -> void:
	pass
	
func _load_scene() -> Node:
	var loadScene: PackedScene = load(packedScene)
	return loadScene.instantiate()
	
func get_room_abbreviation() -> String:
	return ""

## What to do once the event starts
func on_event_started() -> void:
	PlayerManager.is_map_movement_allowed = false
	
## What to do once the event ends
func on_event_ended() -> void:
	PlayerManager.is_map_movement_allowed = true

## Checks the condition for ending the event [br]
## To be overwritten by the child class
func check_event_end_condition() -> bool:
	return false
