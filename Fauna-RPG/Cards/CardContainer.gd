extends Node2D
class_name CardContainer
## Lays out cards in the player's hand and spawns new cards.
##
## When a card is clicked, it is set as the CardManager's queued_card by this class.
## The queued_card can then be accessed from anywhere.
## TODO We need a global way to deal cards so we can deal cards
## from card effects (eg: draw 2 cards). There is also no concept of draw pile/discard pile.


@export var card_scene : PackedScene
@export var total_hand_width : float = 100
@export var card_hovered_offset : float = 100
@export var card_queued_offset : float = 100
@export var default_hand : Array[CardBase]

var cards : Array[CardWorld]
var _card_is_hovered : bool = false


func _ready() -> void:
	PhaseManager.on_phase_changed.connect(_on_phase_changed)
	CardManager.successful_card_play.connect(_on_card_successful_play)


func _process(_delta) -> void:
	_update_card_positions()


func deal_cards() -> void:
	discard_all_cards()
	for card_index in default_hand.size():
		# create card and add to list
		var card_instance : CardWorld = card_scene.instantiate()
		add_child(card_instance)
		cards.append(card_instance)
		card_instance.init_card(default_hand[card_index])
		# bind mouse events
		var card_click_handler = card_instance.get_click_handler()
		card_click_handler.on_click.connect(_on_card_clicked.bind(card_instance))
		card_click_handler.on_mouse_hovering.connect(_on_card_hovering.bind(card_instance))
		card_click_handler.on_unhover.connect(_on_card_unhovered.bind(card_instance))


func discard_all_cards() -> void:
	for card in cards:
		card.queue_free()
	cards.clear()


func remove_card(card : CardWorld) -> void:
	var card_index : int = cards.find(card)
	cards[card_index].queue_free()
	cards.remove_at(card_index)


func _on_phase_changed(new_phase : Enums.Phase, _old_phase : Enums.Phase) -> void:
	if new_phase == Enums.Phase.PLAYER_ATTACKING:
		deal_cards()
	if new_phase == Enums.Phase.ENEMY_ATTACKING:
		discard_all_cards()


func _on_card_clicked(card : CardWorld) -> void:
	if CardManager.is_card_queued():
		CardManager.queued_card.get_lerp_component().desired_position.y = 0
		CardManager.set_queued_card(null)
	else:
		CardManager.set_queued_card(card)
		card.get_lerp_component().desired_position.y = -card_queued_offset


func _on_card_hovering(card : CardWorld) -> void:
	if !CardManager.is_card_queued() and !_card_is_hovered:
		card.get_lerp_component().desired_position.y = -card_hovered_offset
		card.z_index = 1
		_card_is_hovered = true


func _on_card_unhovered(card : CardWorld) -> void:
	if !CardManager.is_card_queued():
		card.get_lerp_component().desired_position.y = 0
		card.z_index = 0
		_card_is_hovered = false


func _on_card_successful_play(card : CardWorld) -> void:
	remove_card(card)


func _update_card_positions() -> void:
	if cards.size() <= 0:
		return
	
	var viewport_width = get_viewport_rect().size.x
	var viewport_height = get_viewport_rect().size.y
	
	# set container to bottom center of screen (doing every frame encase the viewport size changes)
	position.x = viewport_width / 2
	position.x -= total_hand_width / 2
	position.y = viewport_height 
	
	# set spacing of each card
	var per_card_width = 0
	if cards.size() > 1:
		per_card_width = total_hand_width / (cards.size() - 1)
	for card_index in cards.size():
		var card = cards[card_index]
		var card_x = per_card_width * card_index
		
		card.get_lerp_component().desired_position.x = card_x
