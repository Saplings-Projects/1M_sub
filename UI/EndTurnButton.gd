extends Button
## Ends the player's turn when clicked.


func _process(_delta: float) -> void:
	# disable button during enemy attack phase
	disabled = GlobalEnums.CombatPhase.ENEMY_ATTACKING == PhaseManager.current_combat_phase\
				or PhaseManager.current_combat_phase == GlobalEnums.CombatPhase.PLAYER_FINISHING\
				or (PhaseManager.current_combat_phase == GlobalEnums.CombatPhase.PLAYER_ATTACKING\
				and (CardManager.card_container.are_cards_dealing()\
				or CardManager.card_container.is_card_queued()\
				or CardManager.card_container.are_cards_active()))


func _on_pressed() -> void:
	PhaseManager.advance_to_next_combat_phase()
