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
@export var action_tree: Dictionary = {
	"res://Cards/Resource/Card_Damage.tres": NextCardProbability.new(100, load("res://Cards/Resource/Card_Get_block.tres")),
	"res://Cards/Resource/Card_Get_block.tres": NextCardProbability.new(100, load("res://Cards/Resource/Card_Damage.tres"))
}

## The last action that was played
var last_chosen_action: CardBase = null

## Call to choose the next action given the previous action
func choose_next_action() -> CardBase:
	var chosen_action: CardBase = _choose_next_action_inner()
	last_chosen_action = chosen_action
	return chosen_action

## The actual choice function, the inner pattern is used to change [last_chosen_action] easily
func _choose_next_action_inner() -> CardBase:
	var possible_next_action: Array = action_tree[last_chosen_action]
	# checking the total of the probabilities
	var total_probability: int = 0
	for card_probability: NextCardProbability in possible_next_action:
		total_probability += card_probability.probability
	# choose a number between 0 and the total probability -1
	var random_choice: int = randi_range(0, total_probability -1)
	var probability_sum: int = 0
	for card_probability: NextCardProbability in possible_next_action:
		if probability_sum <= random_choice && random_choice < probability_sum + card_probability.probability:
			return card_probability.card
		else:
			probability_sum += card_probability.probability
	push_error("The next action choice for the enemy didn't find a suitable next action, returning default")
	return load("res://Cards/Resource/Card_Damage.tres")
