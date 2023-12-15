extends GutTest
## Tests for cards


var _battler_scene: PackedScene = load("res://Core/Battler.tscn")
var _card_container_scene: PackedScene = load("res://Cards/CardContainer.tscn")
var _battler: Battler = null
var _card_container: CardContainer = null
var _cards_in_hand: Array[CardWorld] = []


func before_each():
	_battler = _battler_scene.instantiate()
	_card_container = _card_container_scene.instantiate()
	
	# fill deck with 50 default cards
	_card_container.default_deck.resize(50)
	_card_container.max_hand_size = 10
	_card_container.starting_hand_size = 5
	
	# assign cards names of Card1-Card50
	for card_index: int in _card_container.default_deck.size():
		_card_container.default_deck[card_index] = CardBase.new()
		_card_container.default_deck[card_index].card_title = "Card" + str(card_index + 1)
	
	get_tree().root.add_child(_battler)
	get_tree().root.add_child(_card_container)
	
	# set draw pile to default deck. This removes any randomness from shuffling on _ready()
	# so each card will have a name Card1-Card50 in the draw pile
	_card_container.draw_pile = _card_container.default_deck.duplicate()


func after_each():
	_battler.queue_free()
	_card_container.queue_free()


func test_draw_cards():
	_card_container.draw_cards(5)
	
	assert_eq(_card_container.cards_in_hand.size(), 5)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 0)


func test_draw_cards_2():
	_card_container.draw_cards(5)
	_card_container.draw_cards(5)
	
	assert_eq(_card_container.cards_in_hand.size(), 10)
	assert_eq(_card_container.draw_pile.size(), 40)
	assert_eq(_card_container.discard_pile.size(), 0)


func test_discard_cards():
	_card_container.draw_cards(5)
	_card_container.discard_random_card(1)
	
	assert_eq(_card_container.cards_in_hand.size(), 4)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 1)


func test_discard_cards_2():
	_card_container.draw_cards(5)
	_card_container.discard_random_card(1)
	_card_container.discard_random_card(1)
	
	assert_eq(_card_container.cards_in_hand.size(), 3)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 2)

func test_discard_all():
	_card_container.draw_cards(5)
	_card_container.discard_all_cards()
	
	assert_eq(_card_container.cards_in_hand.size(), 0)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 5)


func test_deal_starting_hand():
	_card_container.deal_to_starting_hand_size()
	
	assert_eq(_card_container.cards_in_hand.size(), 5)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 0)


func test_draw_to_max():
	_card_container.draw_cards(50)
	
	assert_eq(_card_container.cards_in_hand.size(), 10)
	assert_eq(_card_container.draw_pile.size(), 40)
	assert_eq(_card_container.discard_pile.size(), 0)


func test_discard_specific():
	_card_container.draw_cards(5)
	
	var discard_card: CardWorld = _card_container.cards_in_hand[2]
	
	assert_eq(_card_container.cards_in_hand[0].card_data.card_title, "Card1")
	assert_eq(_card_container.cards_in_hand[1].card_data.card_title, "Card2")
	assert_eq(discard_card.card_data.card_title, "Card3")
	assert_eq(_card_container.cards_in_hand[3].card_data.card_title, "Card4")
	assert_eq(_card_container.cards_in_hand[4].card_data.card_title, "Card5")
	
	_card_container.discard_card(discard_card)
	
	assert_eq(_card_container.cards_in_hand.size(), 4)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 1)
