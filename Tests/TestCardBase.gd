class_name TestCardBase extends GutTest
## Common test setup for CardManager related tests

## The scene for the card container
var _card_container_scene: PackedScene = load("res://Cards/CardContainer.tscn")
## The card container instance
var _card_container: CardContainer = null

## ? What does this do
const SCROLL_CONTAINER_INDEX: int = 2
## ? What does this do
const GRID_CONTAINER_INDEX: int = 0

## Setup the environment before each test [br]
## To be overidden by child tests if they want to do something more or something else [br]
## Child tests that just want to add some stuff can call super to do the initial setup, then their own setup
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
	# Check that everything has been set free properly [br]
	# This is mainly useful for the CI as some tests can fail silently and the only indication is that resources are not freed
	assert_no_new_orphans("Orphans still exist, please free up test resources.")
