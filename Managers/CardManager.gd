extends Node
## Global AutoLoaded class that allows you to get the card container from anywhere.


signal on_card_container_initialized
signal on_card_action_finished(card: CardWorld)

var card_container: CardContainer = null
# We store the current deck in CardManager because we may want to access it outside of battle.
var current_deck: Array[CardBase] = []


func _ready() -> void:
	if SaveManager.has_save_data():
		current_deck.append_array(SaveManager.save_data.saved_deck)


# Call this from CardContainer to initialize. This allows you to get the current CardContainer from
# anywhere by calling CardManager.card_container
func set_card_container(in_card_container: CardContainer) -> void:
	card_container = in_card_container
	on_card_container_initialized.emit()


func save_card_data():
	SaveManager.save_data.saved_deck = current_deck
	
func is_discard_hand_signal_connected(callable: Callable) -> bool:
	return card_container != null and card_container.on_finished_discarding_hand.is_connected(callable)
	
func connect_discard_hand_signal(callable: Callable):
	card_container.on_finished_discarding_hand.connect(callable)

