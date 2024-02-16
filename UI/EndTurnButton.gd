extends Button
## Ends the player's turn when clicked.


func _process(delta: float) -> void:
	# disable button during enemy attack phase
	disabled = Enums.Phase.ENEMY_ATTACKING == PhaseManager.current_phase\
				or PhaseManager.current_phase == Enums.Phase.PLAYER_FINISHING\
				or (PhaseManager.current_phase == Enums.Phase.PLAYER_ATTACKING\
				and (CardManager.card_container.are_cards_dealing()\
				or CardManager.card_container.is_card_queued()\
				or CardManager.card_container.are_cards_active()))


func _on_pressed() -> void:
	PhaseManager.set_phase(Enums.Phase.PLAYER_FINISHING)
	