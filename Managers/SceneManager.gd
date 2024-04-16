extends Node

var current_scene: Node = null

func _ready() -> void:
	var root: Node = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	PhaseManager.on_defeat.connect(on_defeat)
	PhaseManager.on_event_win.connect(on_event_win)

func goto_scene(path: String) -> void:
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path: String) -> void:
	# It is now safe to remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s: Resource = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	

## Used to go to a scene of the given [param event_type], with a sub-selection with [param selection] [br]
## The sub-selection is used if we have multiple scenes for the same event type
func goto_scene_map(event: EventBase, selection: int) -> void:
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	
	# select the name corresponding to the event type
	var actual_event: EventBase = event
	if actual_event == EventRandom:
		actual_event = EventRandom.choose_other_event()
	var event_type_name: String = actual_event.get_event_name()
	# go search the scene of the given event with the given selection
	var path: String = "res://#Scenes/Events/%s/%d.tscn" % [event_type_name, selection] 

	call_deferred("_deferred_goto_scene_map", actual_event, path)
	
## Load the scene and start the event	
func _deferred_goto_scene_map(event: EventBase, path: String) -> void:
	_deferred_goto_scene(path)
	event.on_event_started()


## Shows the defeat scene
func on_defeat() -> void:
	# TODO show defeat screen
	pass
	
func on_event_win() -> void:
	PlayerManager.player_room.room_event.on_event_ended()
