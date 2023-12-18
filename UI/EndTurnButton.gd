extends Button
## Ends the player's turn when clicked.


func _process(delta: float) -> void:
	# disable button during enemy attack phase
	disabled = Enums.Phase.ENEMY_ATTACKING == PhaseManager.current_phase\
				or CardManager.card_container.are_cards_dealing()\
				or CardManager.card_container.is_card_queued()


func _on_pressed() -> void:
	PhaseManager.set_phase(Enums.Phase.ENEMY_ATTACKING)
