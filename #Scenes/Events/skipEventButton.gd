extends Button
class_name SkipEventButton
## Code for the button that allows the player to skip the event in placeholder scenes

## Enable / Disable the button based on the debug variable DEBUG_SKIP_EVENT
func _ready() -> void:
	if not DebugVar.DEBUG_SKIP_EVENT:
		queue_free()
	

## Activate the event ending function when the button is pressed
func _pressed() -> void:
	PlayerManager.player_room.room_event.on_event_ended()
