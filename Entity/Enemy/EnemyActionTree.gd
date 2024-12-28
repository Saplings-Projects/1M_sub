class_name EnemyActionTree extends Resource
## Holds the dictionary which says what are the attacks that can come after a given attack

## The attacks the enemy can do, and which attack they can do after, with which probability [br]
## It should have the format : [br]
## [code]
## {
##  action_1: [(probability, action_2), (other_probability, action_3)],
##  action_2: [(another_probability, action_1), (yet_another_probability, action_3)],
##  ...
## }
## [/code]
## The default is an example using the [NextCardProbability] class, and alternating between damage and block
## This uses the path to the cards as a key
@export var action_tree: Dictionary = {}

## The last action that was played
var last_chosen_action_name: String = "NULL"

## Call to choose the next action given the previous action
func choose_next_action() -> CardBase:
	var chosen_action: CardBase = _choose_next_action_inner()
	last_chosen_action_name = chosen_action.enemy_card_name
	return chosen_action
	
func _init_default_action_tree() -> void:
	if action_tree.is_empty():
		var next_card_prob_1 := NextCardProbability.new()
		next_card_prob_1.probability = 100
		next_card_prob_1.card = load("res://Cards/Resource/Enemy/Normal/Card_Basic_Attack.tres")
		
		var next_card_prob_2 := NextCardProbability.new()
		next_card_prob_2.probability = 100
		next_card_prob_2.card = load("res://Cards/Resource/Both/Card_Get_block.tres")
		
		action_tree["Get_Block"] = [next_card_prob_1]
		action_tree["Basic_Attack"] = [next_card_prob_2]
		

## The actual choice function, the inner pattern is used to change [last_chosen_action] easily
func _choose_next_action_inner() -> CardBase:
	_init_default_action_tree()
	if last_chosen_action_name == "NULL":
		last_chosen_action_name = action_tree.keys()[0]
	var possible_next_action: Array = action_tree[last_chosen_action_name]
	# checking the total of the probabilities
	var total_probability: int = 0
	# this is a NextCardProbability but Godot typing doesn't seem to understand that
	for card_probability: Resource in possible_next_action:
		total_probability += card_probability.probability
	# choose a number between 0 and the total probability -1
	var random_choice: int = randi_range(0, total_probability -1)
	var probability_sum: int = 0
	# this is a NextCardProbability but Godot typing doesn't seem to understand that
	for card_probability: Resource in possible_next_action:
		if probability_sum <= random_choice && random_choice < probability_sum + card_probability.probability:
			return card_probability.card
		else:
			probability_sum += card_probability.probability
	push_error("The next action choice for the enemy didn't find a suitable next action, returning default")
	return load("res://Cards/Resource/Enemy/Normal/Card_Basic_Attack.tres")
