extends Node
## Global AutoLoaded class that allows you to get the card container from anywhere.


signal on_card_container_initialized
signal on_card_action_finished(card: CardWorld)
signal on_deck_initialized

var card_container: CardContainer = null
# We store the current deck in CardManager because we may want to access it outside of battle.
var current_deck: Array[CardBase] = []


func _ready():
	# Save data before the SaveManager is destroyed.
	SaveManager.on_pre_save.connect(_save_persistent_data)


# Call this from CardContainer to initialize. This allows you to get the current CardContainer from
# anywhere by calling CardManager.card_container
func set_card_container(in_card_container: CardContainer) -> void:
	card_container = in_card_container
	on_card_container_initialized.emit()
	
	if in_card_container != null:
		_initialize_deck()


func _initialize_deck():
	# Set our default deck from the card container. Then we try to override the deck with save data
	current_deck = card_container.default_deck.duplicate()
	_load_persistent_data()
	on_deck_initialized.emit()


func _load_persistent_data():
	# If the saved deck is empty, we assume there is no save data
	# NOTE: This will not work if the player has 0 cards in their deck somehow.
	if SaveManager.save_data.saved_deck.is_empty():
		return
	
	current_deck.clear()
	current_deck.append_array(SaveManager.save_data.saved_deck)


func _save_persistent_data():
	SaveManager.save_data.saved_deck.clear()
	SaveManager.save_data.saved_deck.append_array(current_deck)


func is_discard_hand_signal_connected(callable: Callable) -> bool:
	return card_container != null and card_container.on_finished_discarding_hand.is_connected(callable)


func connect_discard_hand_signal(callable: Callable):
	card_container.on_finished_discarding_hand.connect(callable)

