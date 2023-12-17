extends Control
class_name CardContainer
## Lays out cards in the player's hand and spawns new cards.
##
## When a card is clicked, it is set as the queued_card.
## When a card is queued, you can't hover any other cards in your deck. Left click any card to
## remove the current card from the queue.
## TODO Right click cancels the queued card instead?


signal on_card_counts_updated

@export var card_scene: PackedScene
@export var total_hand_width: float = 100
@export var card_hovered_offset: float = 100
@export var card_queued_offset: float = 100
@export var default_deck: Array[CardBase]
@export var starting_hand_size: int = 5
@export var max_hand_size: int = 10
@export var card_draw_time: float = 0.2
@export var card_discard_time: float = 0.1
@export var max_hand_width: float = 100
@export var min_card_separation: float = 100
@export var max_card_separation: float = 100
@export var draw_pile_ui: DrawPileUISetter = null
@export var discard_pile_ui: DiscardPileUISetter = null

var cards_in_hand: Array[CardWorld] = []
var draw_pile: Array[CardBase] = []
var discard_pile: Array[CardBase] = []
var queued_card: CardWorld = null

var _cards_queued_for_add: Array[CardBase] = []
var _draw_timer: SceneTreeTimer = null
var _cards_queued_for_discard: Array[CardWorld] = []
var _discard_timer: SceneTreeTimer = null


func _ready() -> void:
	PhaseManager.on_phase_changed.connect(_on_phase_changed)
	CardManager.set_card_container(self)
	
	_init_default_draw_pile()


func _process(_delta: float) -> void:
	_update_card_positions()


func set_queued_card(card: CardWorld) -> void:
	queued_card = card


func remove_queued_card() -> void:
	discard_card(queued_card)
	set_queued_card(null)


func is_card_queued() -> bool:
	return queued_card != null


func deal_to_starting_hand_size() -> void:
	# deal to our starting hand size, ignoring amount of cards we already have
	var amount_to_draw: int = maxi(0, starting_hand_size - cards_in_hand.size())
	draw_cards(amount_to_draw)


func draw_cards(amount: int) -> void:
	for card_index: int in amount:
		# limit amount of cards to a maximum
		if cards_in_hand.size() < max_hand_size:
			_draw_card()


func discard_all_cards() -> void:
	# Discard cards until our hand is empty. We do it with a while-loop instead of a for-loop
	# because we don't want cards_in_hand to change size during the iteration
	while cards_in_hand.size() > 0:
		_discard_last_card()


func discard_random_card(amount: int) -> void:
	# Discard - clamping desired amount to the size of our current hand
	var amount_to_discard: int = mini(cards_in_hand.size(), amount)
	for discarding_index: int in amount_to_discard:
		var random_index: int = Helpers.get_random_array_index(cards_in_hand)
		discard_card(cards_in_hand[random_index])


func discard_card(card: CardWorld) -> void:
	var card_index: int = cards_in_hand.find(card)
	_discard_card_at_index(card_index)


func get_draw_pile_size() -> int:
	return draw_pile.size()


func get_discard_pile_size() -> int:
	return discard_pile.size()


func _init_default_draw_pile() -> void:
	draw_pile = default_deck.duplicate()
	draw_pile.shuffle()


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
	
	_add_to_card_draw_queue(drawn_card)
	
	on_card_counts_updated.emit()


func _create_card_in_world(card_data: CardBase) -> void:
	var card: CardWorld = card_scene.instantiate()
	add_child(card)
	cards_in_hand.append(card)

	card.init_card(card_data)
	
	card.global_position = draw_pile_ui.global_position
	_update_card_positions()
	card.get_card_movement_component().set_movement_state(Enums.CardMovementState.MOVING_TO_HAND)
	
	_bind_card_input(card)


func _bind_card_input(card: CardWorld):
	# bind mouse events
	var card_click_handler: ClickHandler = card.get_click_handler()
	card_click_handler.on_click.connect(_on_card_clicked.bind(card))
	card_click_handler.on_mouse_hovering.connect(_on_card_hovering.bind(card))
	card_click_handler.on_unhover.connect(_on_card_unhovered.bind(card))


func _discard_card_at_index(card_index: int) -> void:
	var card: CardWorld = cards_in_hand[card_index]
	
	# add to discard pile
	discard_pile.append(card.card_data)
	
	# remove from hand and add to discard queue
	cards_in_hand.remove_at(card_index)
	_add_to_discard_queue(card)
	
	on_card_counts_updated.emit()


func _discard_last_card() -> void:
	if cards_in_hand.size() > 0:
		_discard_card_at_index(cards_in_hand.size() - 1)



func _add_to_card_draw_queue(card: CardBase):
	_cards_queued_for_add.append(card)
	_handle_card_draw_queue()


# Final place where a card is created and added to the world
func _handle_card_draw_queue():
	if _draw_timer != null:
		return
	
	_draw_timer = get_tree().create_timer(card_draw_time)
	await _draw_timer.timeout
	_draw_timer = null

	var card_data: CardBase = _cards_queued_for_add[0]
	_cards_queued_for_add.remove_at(0)
	
	_create_card_in_world(card_data)
	
	if _cards_queued_for_add.size() > 0:
		_handle_card_draw_queue()


func _add_to_discard_queue(card: CardWorld) -> void:
	_cards_queued_for_discard.append(card)
	_handle_discard_queue()


# Final place where a card is discarded and removed from the world
func _handle_discard_queue() -> void:
	if _discard_timer != null:
		return
	
	_discard_timer = get_tree().create_timer(card_discard_time)
	await _discard_timer.timeout
	_discard_timer = null
	
	var card: CardWorld = _cards_queued_for_discard[0]
	_cards_queued_for_discard.remove_at(0)
	
	card.get_card_movement_component().state_properties.desired_position = discard_pile_ui.global_position
	card.get_card_movement_component().set_movement_state(Enums.CardMovementState.DISCARDING)
	
	if _cards_queued_for_discard.size() > 0:
		_handle_discard_queue()


func _on_phase_changed(new_phase: Enums.Phase, _old_phase: Enums.Phase) -> void:
	if new_phase == Enums.Phase.PLAYER_ATTACKING:
		deal_to_starting_hand_size()
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
	card.get_card_movement_component().state_properties.desired_position.y = -offset
	card.z_index = 1


func _unfocus_card(card: CardWorld) -> void:
	card.get_card_movement_component().state_properties.desired_position.y = 0
	card.z_index = 0


func _update_card_positions() -> void:
	var amount_of_cards: int = cards_in_hand.size()
	
	if amount_of_cards <= 0:
		return
	
	# set hand width to the max of all our card separations
	var per_card_width: float = max_card_separation
	var current_hand_width: float = 0
	if amount_of_cards > 1:
		current_hand_width = per_card_width * (amount_of_cards - 1)
	
	# if our width is over the set maximum, reduce down the width between cards
	if current_hand_width > max_hand_width:
		var hand_over_max_delta: float = current_hand_width - max_hand_width
		var new_separation: float = hand_over_max_delta / amount_of_cards
		
		per_card_width -= new_separation
		per_card_width = maxf(per_card_width, min_card_separation)
		
		current_hand_width = per_card_width * (amount_of_cards - 1)
	
	var half_hand_width: float = current_hand_width / 2.0
	
	for card_index: int in amount_of_cards:
		var card: CardWorld = cards_in_hand[card_index]
		var movement_component: CardMovementComponent = card.get_card_movement_component()
		var move_state: Enums.CardMovementState = movement_component.current_move_state
		
		var card_x: float = per_card_width * card_index
		
		# center cards
		card_x -= half_hand_width
		
		movement_component.state_properties.desired_position.x = card_x
