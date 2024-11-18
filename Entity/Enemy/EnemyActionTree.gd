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
@export var action_tree: Dictionary = {
	load("res://Cards/Resource/Card_Damage.tres"): NextCardProbability.new(100, load("res://Cards/Resource/Card_Get_block.tres")),
	load("res://Cards/Resource/Card_Get_block.tres"): NextCardProbability.new(100, load("res://Cards/Resource/Card_Damage.tres"))
}

