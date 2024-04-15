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

## The name used to identify the event in the filesystem (scenes and such)
func get_event_name() -> String:
	return "base"

## What to do once the event starts
func on_event_started() -> void:
	PlayerManager.is_map_movement_allowed = false
	
## What to do once the event ends
func on_event_ended() -> void:
	PlayerManager.is_map_movement_allowed = true

