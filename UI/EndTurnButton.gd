extends Button
## Ends the player's turn when clicked.


func _ready() -> void:
	PhaseManager.on_phase_changed.connect(_on_phase_changed)


func _on_phase_changed(new_phase: Enums.Phase, _old_phase: Enums.Phase) -> void:
	# disable button during enemy attack phase
	disabled = new_phase == Enums.Phase.ENEMY_ATTACKING


func _on_pressed() -> void:
	PhaseManager.set_phase(Enums.Phase.ENEMY_ATTACKING)
