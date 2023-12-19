extends Resource
class_name Event

#const EVENTS_CLASSIFICATION = [Event_Mob, Event_Random, Event_Shop, Event_Heal]

var packedScene: String = ""

# Initialize Event
func _init(scene: String) -> void:
	packedScene = scene
	
func _update_event() -> void:
	pass
	
func _load_scene() -> Node:
	var loadScene: PackedScene = load(packedScene)
	return loadScene.instantiate()
	
