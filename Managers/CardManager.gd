extends Node
## Global AutoLoaded class that allows you to get the card container from anywhere.


signal on_card_container_initialized
signal on_card_action_finished(card: CardWorld)
signal on_deck_initialized

var card_container: CardContainer = null
# We store the current deck in CardManager because we may want to access it outside of battle.
var current_deck: Array[CardBase] = []


func _exit_tree():
	_save_persistent_data()


# Call this from CardContainer to initialize. This allows you to get the current CardContainer from
# anywhere by calling CardManager.card_container
func set_card_container(in_card_container: CardContainer) -> void:
	card_container = in_card_container
	on_card_container_initialized.emit()
	
	if in_card_container != null:
		_handle_load_defaults()
		
		on_deck_initialized.emit()


func _handle_load_defaults():
	# If this is our first run, use the default deck and save
	if SaveManager.is_first_time_initialization():
		current_deck.clear()
		current_deck = card_container.default_deck
		_save_persistent_data()
	else:
		_load_persistent_data()


func _load_persistent_data():
	current_deck.clear()
	current_deck.append_array(SaveManager.save_data.saved_deck)


func _save_persistent_data():
	SaveManager.save_data.saved_deck.clear()
	SaveManager.save_data.saved_deck.append_array(current_deck)


func is_discard_hand_signal_connected(callable: Callable) -> bool:
	return card_container != null and card_container.on_finished_discarding_hand.is_connected(callable)
	
func connect_discard_hand_signal(callable: Callable):
	card_container.on_finished_discarding_hand.connect(callable)

