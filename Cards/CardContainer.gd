extends Node2D
class_name CardContainer
## Lays out cards in the player's hand and spawns new cards.
##
## When a card is clicked, it is set as the CardManager's queued_card by this class.
## The queued_card can then be accessed from anywhere.
## When a card is queued, you can't hover any other cards in your deck. Left click any card to
## remove the current card from the queue.
## TODO Right click cancels the queued card instead?
## TODO We need a global way to deal cards so we can deal cards from
## card effects (eg: draw 2 cards). There is also no concept of draw pile/discard pile.

signal on_card_counts_updated

@export var card_scene: PackedScene
@export var total_hand_width: float = 100
@export var card_hovered_offset: float = 100
@export var card_queued_offset: float = 100
@export var default_deck: Array[CardBase]
@export var starting_hand_size: int = 5
@export var max_hand_size: int = 10

var cards_in_hand: Array[CardWorld] = []
var draw_pile: Array[CardBase] = []
var discard_pile: Array[CardBase] = []
var queued_card: CardWorld = null


func _ready() -> void:
	PhaseManager.on_phase_changed.connect(_on_phase_changed)
	CardManager.set_card_container(self)
	
	draw_pile = default_deck.duplicate()
	draw_pile.shuffle()


func _process(_delta: float) -> void:
	_update_card_positions()


func set_queued_card(card: CardWorld) -> void:
	queued_card = card


func remove_queued_card() -> void:
	discard_card(queued_card)
	set_queued_card(null)


func is_card_queued() -> bool:
	return queued_card != null


func deal_to_hand_limit() -> void:
	# deal to our starting hand size, ignoring amount of cards we already have
	var amount_to_draw: int = maxi(0, starting_hand_size - cards_in_hand.size())
	draw_cards(amount_to_draw)


func draw_cards(amount: int) -> void:
	for card_index: int in amount:
		# limit amount of cards to a maximum
		if cards_in_hand.size() < max_hand_size:
			_draw_card()


func discard_all_cards() -> void:
	while cards_in_hand.size() > 0:
		_discard_last_card()


func discard_random_card(amount: int) -> void:
	var valid_cards_to_discard: Array[CardWorld] = []
	
	for card in cards_in_hand:
		if card != queued_card:
			valid_cards_to_discard.append(card)
	
	var amount_to_discard: int = mini(valid_cards_to_discard.size(), amount)
	for discarding_index: int in amount_to_discard:
		var random_index: int = Helpers.get_random_array_index(valid_cards_to_discard)
		discard_card(valid_cards_to_discard[random_index])
		valid_cards_to_discard.remove_at(random_index)


func discard_card(card: CardWorld) -> void:
	var card_index: int = cards_in_hand.find(card)
	_discard_card_at_index(card_index)


func get_draw_pile_size() -> int:
	return draw_pile.size()


func get_discard_pile_size() -> int:
	return discard_pile.size()


func _draw_card() -> void:
	# if draw pile is empty, shuffle discard pile into draw pile. Clear discard pile.
	if draw_pile.size() <= 0:
		# every card is in our hand. Exit because there's nothing to draw
		if discard_pile.size() <= 0:
			return
		discard_pile.shuffle()
		draw_pile = discard_pile.duplicate()
		discard_pile.clear()
	
	# top card on the draw pile
	var drawn_card: CardBase = draw_pile[0]
	draw_pile.remove_at(0)
	
	_create_card_in_world(drawn_card)
	
	on_card_counts_updated.emit()


func _create_card_in_world(card_data: CardBase):
	var card_instance: CardWorld = card_scene.instantiate()
	add_child(card_instance)
	cards_in_hand.append(card_instance)

	card_instance.init_card(card_data)
	
	# bind mouse events
	var card_click_handler: ClickHandler = card_instance.get_click_handler()
	card_click_handler.on_click.connect(_on_card_clicked.bind(card_instance))
	card_click_handler.on_mouse_hovering.connect(_on_card_hovering.bind(card_instance))
	card_click_handler.on_unhover.connect(_on_card_unhovered.bind(card_instance))


func _discard_card_at_index(card_index: int) -> void:
	var card: CardWorld = cards_in_hand[card_index]
	
	# add to discard pile
	discard_pile.append(card.card_data)
	
	# remove from world
	cards_in_hand.remove_at(card_index)
	card.queue_free()
	
	on_card_counts_updated.emit()


func _discard_last_card() -> void:
	if cards_in_hand.size() > 0:
		_discard_card_at_index(cards_in_hand.size() - 1)


func _on_phase_changed(new_phase: Enums.Phase, _old_phase: Enums.Phase) -> void:
	if new_phase == Enums.Phase.PLAYER_ATTACKING:
		deal_to_hand_limit()
	if new_phase == Enums.Phase.ENEMY_ATTACKING:
		discard_all_cards()


func _on_card_clicked(card: CardWorld) -> void:
	if is_card_queued():
		var previously_queued_card: CardWorld = queued_card
		
		# If we click ANY card while we have one queued, unqueue the queued card
		set_queued_card(null)
		
		# If the card we clicked was the global queued card, we are still hovering it
		if card == previously_queued_card:
			_on_card_hovering(card)
		else:
			# If we clicked another card, then we already unhovered the queued card
			_on_card_unhovered(previously_queued_card)
			# Now call this function again for the card we clicked, which should queue it
			_on_card_clicked(card)
	else:
		# If we click a card with no card queued, queue it
		set_queued_card(card)
		_focus_card(card, card_queued_offset)
		
		# Unfocus all other cards
		for other_card in cards_in_hand:
			if other_card == card:
				continue
			_unfocus_card(other_card)


func _on_card_hovering(card: CardWorld) -> void:
	if !is_card_queued():
		_focus_card(card, card_hovered_offset)


func _on_card_unhovered(card: CardWorld) -> void:
	if !is_card_queued():
		_unfocus_card(card)


func _focus_card(card: CardWorld, offset: float) -> void:
	card.get_lerp_component().desired_position.y = -offset
	card.z_index = 1


func _unfocus_card(card: CardWorld) -> void:
	card.get_lerp_component().desired_position.y = 0
	card.z_index = 0


func _update_card_positions() -> void:
	if cards_in_hand.size() <= 0:
		return
	
	var viewport_width: float = get_viewport_rect().size.x
	var viewport_height: float = get_viewport_rect().size.y
	
	# set container to bottom center of screen (doing every frame encase the viewport size changes)
	position.x = viewport_width / 2
	position.x -= total_hand_width / 2
	position.y = viewport_height 
	
	# set spacing of each card
	var per_card_width: float = 0
	if cards_in_hand.size() > 1:
		per_card_width = total_hand_width / (cards_in_hand.size() - 1)
	for card_index: int in cards_in_hand.size():
		var card: CardWorld = cards_in_hand[card_index]
		var card_x: float = per_card_width * card_index

		card.get_lerp_component().desired_position.x = card_x
