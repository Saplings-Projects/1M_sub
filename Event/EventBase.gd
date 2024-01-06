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
	
