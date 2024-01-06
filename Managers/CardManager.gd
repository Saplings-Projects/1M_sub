extends Node
## Global AutoLoaded class that allows you to get the card container from anywhere.


signal on_card_container_initialized
signal on_card_action_finished(card: CardWorld)

var card_container: CardContainer = null


# Call this from CardContainer to initialize. This allows you to get the current CardContainer from
# anywhere by calling CardManager.card_container
func set_card_container(in_card_container: CardContainer) -> void:
	card_container = in_card_container
	on_card_container_initialized.emit()
