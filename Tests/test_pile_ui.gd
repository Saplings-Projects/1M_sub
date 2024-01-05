extends GutTest
#test for ui pop up

var _card_container_scene: PackedScene = load("res://Cards/CardContainer.tscn")
var _card_container_scroll_scene: PackedScene  = load("res://#Scenes/CardScrollUI.tscn")
var _card_container: CardContainer = null
var _card_scroll: Control = null

const SCROLL_CONTAINER_INDEX: int = 2
const GRID_CONTAINER_INDEX: int = 0

func before_all():
	_card_container = _card_container_scene.instantiate()
	# fill deck with 50 default cards
	_card_container.default_deck.resize(50)
	_card_container.max_hand_size = 10
	_card_container.starting_hand_size = 0
	_card_container.card_draw_time = .05

func before_each():

	# assign cards names of Card1-Card50
	for card_index: int in _card_container.default_deck.size():
		_card_container.default_deck[card_index] = CardBase.new()
		_card_container.default_deck[card_index].card_title = "Card" + str(card_index + 1)
	
	get_tree().root.add_child(_card_container)
	

func after_each():
	
	
	_card_container.free()
	_card_scroll.free()
	
func test_populate():
	
	_card_scroll = _card_container_scroll_scene.instantiate()
	_card_scroll.deck_pile = _card_container.default_deck.duplicate()

	_card_scroll.populate("DeckPile")

	var card_pile = _card_scroll.deck_pile
	var grid: GridContainer = _card_scroll.get_child(SCROLL_CONTAINER_INDEX).get_child(GRID_CONTAINER_INDEX)

	for card_index in len(card_pile):
		var card_data_deck = card_pile[card_index]
		var card_data_grid = grid.get_child(card_index).card_data

		assert_eq(card_data_deck, card_data_grid)
