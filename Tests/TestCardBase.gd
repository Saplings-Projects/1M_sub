class_name TestCardBase extends GutTest

var _card_container_scene: PackedScene = load("res://Cards/CardContainer.tscn")
var _card_container: CardContainer = null


const SCROLL_CONTAINER_INDEX: int = 2
const GRID_CONTAINER_INDEX: int = 0

func before_each() -> void:
	_card_container = _card_container_scene.instantiate()
	
	# fill deck with 50 default cards
	CardManager.current_deck.resize(50)
	_card_container.max_hand_size = 10
	_card_container.starting_hand_size = 0
	_card_container.card_draw_time = .05
	
	# assign cards names of Card1-Card50
	for card_index: int in CardManager.current_deck.size():
		CardManager.current_deck[card_index] = CardBase.new()
		CardManager.current_deck[card_index].card_title = "Card" + str(card_index + 1)
	
	get_tree().root.add_child(_card_container)
	

func after_each() -> void:
	_card_container.queue_free()
	CardManager.current_deck.clear()
	assert_no_new_orphans("Orphans still exist, please free up test resources.")
