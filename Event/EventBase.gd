extends Resource
class_name EventBase
## The base of all events
##
## An event is one of the scene type that can be loaded when entering a new room on the map
## A few examples of events are: Combat(Mob), Heal, Shop, Random etc.


## The path to the scene to load
var packedScene: String = ""

## Initialize Event
## To be overriden by child classes
func _init() -> void:
	pass
	
## Update Event
## To be overriden by child classes
func _update_event() -> void:
	pass
	
## Give an instance of the scene
func _load_scene() -> Node:
	var loadScene: PackedScene = load(packedScene)
	return loadScene.instantiate()
	
## The name of the room / event
func get_room_abbreviation() -> String:
	return ""
