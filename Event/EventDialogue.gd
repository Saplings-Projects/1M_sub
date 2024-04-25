class_name EventDialogue extends EventBase
## Dialogue event

## The dialogue resource to use
@export var dialog: DialogueResource = load("res://Dialog/test.dialogue")
## Event title
@export var title: String = "test"

## @Override [br]
## See [EventBase] for more information [br]
func _init() -> void:
	pass
	
## @Override [br]
## See [EventBase] for more information [br]
func _update_event() -> void:
	print("Update Dialogue")

## @Override [br]
## See [EventBase] for more information [br]
func get_room_abbreviation() -> String:
	return "D"
	
## @Override	
## The name used to identify the event in the filesystem (scenes and such)
func get_event_name() -> String:
	return "dialogue"
	
## @Override
func on_event_started() -> void:
	super()
	DialogueManager.show_dialogue_balloon(dialog, title)
	
## @Override
func on_event_ended() -> void:
	super()
	print("Dialogue event ended")
