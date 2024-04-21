extends Button
## Code for the button that allows the player to skip the event in placeholder scenes

## Enable / Disable the button based on the debug variable DEBUG_SKIP_EVENT
func _ready() -> void:
	self.disabled = not DebugVar.DEBUG_SKIP_EVENT
	

## Activate the event ending function when the button is pressed
func _on_pressed() -> void:
	PlayerManager.player_room.room_event.on_event_ended()
