extends Resource
class_name EventBase

var EVENTS_CLASSIFICATION: Array[Resource] = [EventMob, EventRandom, EventShop, EventHeal]
# ! this should be done by an enum, because having an array of classes is not gonna work nicely
# plus it should probably be EventMob.new() instead of EventMob

var packedScene: String = ""

# Initialize Event
func _init() -> void:
	pass
	
func _update_event() -> void:
	pass
	
func _load_scene() -> Node:
	var loadScene: PackedScene = load(packedScene)
	return loadScene.instantiate()
	
