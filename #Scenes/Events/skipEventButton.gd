extends Button

func _ready() -> void:
	self.disabled = not DebugVar.DEBUG_SKIP_EVENT
	

func _on_pressed() -> void:
	PlayerManager.player_room.room_event.on_event_ended()
