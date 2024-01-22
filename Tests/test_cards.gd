extends GutTest
## Tests for cards


var _card_container_scene: PackedScene = load("res://Cards/CardContainer.tscn")
var _card_container: CardContainer = null


func before_each():
	_card_container = _card_container_scene.instantiate()
	
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
	
	# set draw pile to default deck. This removes any randomness from shuffling on _ready()
	# so each card will have a name Card1-Card50 in the draw pile
	_card_container.draw_pile = _card_container.default_deck.duplicate()


func after_each():
	_card_container.queue_free()


func test_draw_cards():
	_card_container.draw_cards(5)
	await _card_container.on_cards_finished_dealing
	
	assert_eq(_card_container.cards_in_hand.size(), 5)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 0)


func test_draw_cards_2():
	_card_container.draw_cards(5)
	_card_container.draw_cards(5)
	await _card_container.on_cards_finished_dealing
	
	assert_eq(_card_container.cards_in_hand.size(), 10)
	assert_eq(_card_container.draw_pile.size(), 40)
	assert_eq(_card_container.discard_pile.size(), 0)


func test_discard_cards():
	_card_container.draw_cards(5)
	await _card_container.on_cards_finished_dealing
	_card_container.discard_random_card(1)
	
	assert_eq(_card_container.cards_in_hand.size(), 4)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 1)


func test_discard_cards_2():
	_card_container.draw_cards(5)
	await _card_container.on_cards_finished_dealing
	_card_container.discard_random_card(1)
	_card_container.discard_random_card(1)
	
	assert_eq(_card_container.cards_in_hand.size(), 3)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 2)

func test_discard_all():
	_card_container.draw_cards(5)
	await _card_container.on_cards_finished_dealing
	_card_container.discard_all_cards()
	
	assert_eq(_card_container.cards_in_hand.size(), 0)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 5)


func test_deal_starting_hand():
	_card_container.starting_hand_size = 5
	_card_container.deal_to_starting_hand_size()
	await _card_container.on_cards_finished_dealing
	
	assert_eq(_card_container.cards_in_hand.size(), 5)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 0)


func test_draw_to_max():
	_card_container.draw_cards(50)
	await _card_container.on_cards_finished_dealing
	
	assert_eq(_card_container.cards_in_hand.size(), 10)
	assert_eq(_card_container.draw_pile.size(), 40)
	assert_eq(_card_container.discard_pile.size(), 0)


func test_discard_specific():
	_card_container.draw_cards(5)
	await _card_container.on_cards_finished_dealing
	
	var discard_card: CardWorld = _card_container.cards_in_hand[2]
	
	assert_eq(discard_card.card_data.card_title, "Card3")
	
	_card_container.discard_card(discard_card)
	
	assert_eq(_card_container.cards_in_hand[0].card_data.card_title, "Card1")
	assert_eq(_card_container.cards_in_hand[1].card_data.card_title, "Card2")
	assert_eq(_card_container.cards_in_hand[2].card_data.card_title, "Card4")
	assert_eq(_card_container.cards_in_hand[3].card_data.card_title, "Card5")
	
	assert_eq(_card_container.cards_in_hand.size(), 4)
	assert_eq(_card_container.draw_pile.size(), 45)
	assert_eq(_card_container.discard_pile.size(), 1)
	
func test_play_card_action_flow():
	_card_container.draw_cards(10)
	await _card_container.on_cards_finished_dealing
	
	# Simulate queueing up a card
	var _queued_card: CardWorld = _card_container.cards_in_hand[0]
	_card_container.set_queued_card(_queued_card)
	
	assert_eq(_card_container.cards_in_hand.size(), 10)
	assert_true(_card_container.is_card_queued(), "Card has not been queued yet.")
	
	# Simulate removing queued card to set it to active
	_card_container.remove_queued_card()
	
	assert_eq(_card_container.cards_in_hand.size(), 9, "Card has not been removed from hand")
	assert_false(_card_container.is_card_queued(), "Card is still queued.")
	assert_eq(_card_container._cards_queued_for_discard.size(), 1, "Card to remove from hand has not been queued for discard.")
	assert_eq(_card_container.discard_pile.size(), 0, "Discard pile has been populated too early")
	
	# Simulate setting active card to play
	_card_container.set_active_card(_queued_card.card_data)
	
	assert_true(_card_container.are_cards_active(), "No card is currently active")
	
	# Simulate finishing the card action
	_card_container.finish_active_card_action(_queued_card.card_data)
	
	assert_eq(_card_container.cards_in_hand.size(), 9, "Card has not been removed from hand")
	assert_false(_card_container.are_cards_active(), "Card is still currently active")
	assert_eq(_card_container._cards_queued_for_discard.size(), 0, "Card has not been removed from discard queue")
	assert_eq(_card_container.discard_pile.size(), 1, "Discard pile has not been populated yet")
	
	
