extends GutTest
#test for ui pop up

var _card_container_scene: PackedScene = load("res://Cards/CardContainer.tscn")
var _card_container_scroll_scene: PackedScene  = load("res://#Scenes/CardScrollUI.tscn")
var _card_container: CardContainer = null
var _card_scroll: Control = null


func _test_setter():
	_card_container = _card_container_scene.instantiate()
	_card_scroll = _card_container_scroll_scene.instantiate()
	
	# fill deck with 50 default cards
	_card_container.default_deck.resize(50)
	_card_container.max_hand_size = 10
	_card_container.starting_hand_size = 0
	_card_container.card_draw_time = .05
	
	# assign cards names of Card1-Card50
	for card_index: int in _card_container.default_deck.size():
		_card_container.default_deck[card_index] = CardBase.new()
		_card_container.default_deck[card_index].card_title = "Card" + str(card_index + 1)
	
	get_tree().root.add_child(_card_container)

	
	_card_scroll.discard_pile = _card_container.default_deck.duplicate()
	_card_scroll.deck_pile = _card_container.default_deck.duplicate()
	_card_scroll.draw_pile = _card_container.default_deck.duplicate()

func test_populate():
	
	_test_setter()
	_card_scroll.populate("DeckPile")

	var cards_in_pile: int = len(_card_scroll.deck_pile)
	var grid: GridContainer = _card_scroll.get_node("GridContainer")

	assert_eq(cards_in_pile, grid.get_child_count())
	


