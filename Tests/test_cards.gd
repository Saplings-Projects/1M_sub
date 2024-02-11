extends TestCardBase
## Tests for cards


# @Override
func before_each():
	super()
	
	# set draw pile to default deck. This removes any randomness from shuffling on _ready()
	# so each card will have a name Card1-Card50 in the draw pile
	_card_container.draw_pile = _card_container.default_deck.duplicate()


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
	_card_container.queued_for_active()

	assert_eq(_card_container.cards_in_hand.size(), 9, "Card has not been removed from hand")
	assert_eq(_card_container.discard_pile.size(), 0, "Discard pile has been populated too early")

	# Simulate setting active card to play
	_card_container.set_active_card(_queued_card)
	
	assert_true(_card_container.are_cards_active(), "No card is currently active")
	
	# Removed the queued card
	_card_container.set_queued_card(null)
	
	assert_false(_card_container.is_card_queued(), "Card is still queued.")

	# Simulate finishing the card action
	_card_container.finish_active_card_action(_queued_card.card_data)

	assert_eq(_card_container.cards_in_hand.size(), 9, "Card has not been removed from hand")
	assert_false(_card_container.are_cards_active(), "Card is still currently active")
	assert_eq(_card_container._cards_queued_for_discard.size(), 0, "Card has not been removed from discard queue")
	assert_eq(_card_container.discard_pile.size(), 1, "Discard pile has not been populated yet")
