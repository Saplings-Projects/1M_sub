extends Button
## Control the functions of the return button on the map scene.

## Disable the return button if the player is not in a room yet.
func _ready() -> void:
	self.disabled = not PlayerManager.is_player_initial_position_set
