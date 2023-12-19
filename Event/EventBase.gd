extends Resource
class_name EventBase

const EVENTS_CLASSIFICATION: Array[EventBase] = [EventMob.new(""), EventRandom.new(""), EventShop.new(""), EventHeal.new("")]

var packedScene: String = ""

# Initialize Event
func _init(scene: String) -> void:
	packedScene = scene
	
func _update_event() -> void:
	pass
	
func _load_scene() -> Node:
	var loadScene: PackedScene = load(packedScene)
	return loadScene.instantiate()
	
