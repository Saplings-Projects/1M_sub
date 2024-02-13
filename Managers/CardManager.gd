extends Node
## Global AutoLoaded class that allows you to get the card container from anywhere.


signal on_card_container_initialized
signal on_card_action_finished(card: CardWorld)
signal on_deck_initialized

var card_container: CardContainer = null
# We store the current deck in CardManager because we may want to access it outside of battle.
var current_deck: Array[CardBase] = []


# Call this from CardContainer to initialize. This allows you to get the current CardContainer from
# anywhere by calling CardManager.card_container
func set_card_container(in_card_container: CardContainer) -> void:
	card_container = in_card_container
	on_card_container_initialized.emit()
	
	if in_card_container != null:
		_initialize_deck()


func _initialize_deck() -> void:
	# Set our default deck from the card container.
	# NOTE: We assume that if the current_deck is empty, then this is the first time the game was loaded.
	# So we load the default deck stored in the card container.
	# TODO: It would be better to store default_deck in a separate Resource file
	# so we don't rely on the card_container here.
	if current_deck.is_empty():
		current_deck = card_container.default_deck.duplicate()
	on_deck_initialized.emit()


func is_discard_hand_signal_connected(callable: Callable) -> bool:
	return card_container != null and card_container.on_finished_discarding_hand.is_connected(callable)


func connect_discard_hand_signal(callable: Callable):
	card_container.on_finished_discarding_hand.connect(callable)

