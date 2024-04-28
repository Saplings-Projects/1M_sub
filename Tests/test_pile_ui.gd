extends TestCardBase
## Test the deck pile

var _card_container_scroll_scene: PackedScene  = load("res://#Scenes/CardScrollUI.tscn")
var _card_scroll: Control = null


# @Override
func before_each() -> void:
	super()
	_card_scroll = _card_container_scroll_scene.instantiate()
	_card_scroll.populate("DeckPile")


# @Override
func after_each() -> void:
	_card_container.queue_free()
	_card_scroll.free()
	assert_no_new_orphans("Orphans still exist, please free up test resources.")


func test_populate() -> void:
	var card_pile: Array[CardBase] = CardManager.current_deck.duplicate()
	var grid: GridContainer = _card_scroll.get_child(SCROLL_CONTAINER_INDEX).get_child(GRID_CONTAINER_INDEX)

	for card_index: int in len(card_pile):
		var card_data_deck: CardBase = card_pile[card_index]
		var card_data_grid: CardBase = grid.get_child(card_index).card_data

		assert_eq(card_data_deck, card_data_grid)
