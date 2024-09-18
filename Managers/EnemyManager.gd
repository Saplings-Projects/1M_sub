extends Node
## Globally accessible for easy access to the enemies
## They are for now only accessible through the battler which is not very practical

## Distribution of enemies over the floors [br]
## The values are arrays of PackedScene [br]
## The keys are of format (X,Y,Z) with X the tree section from 1 to 3, 
## Y the lower percent at which the enemy groups of the corresponding value are found,
## Z the higher percent at which the enemy groups of the corresponding vlaue are found [br]
## The intervals defined by the values are continuous, successive and non-overlapping.
@export var enemy_group_distribution: Dictionary = {
	[1, 0, 20]: [], # an array of packed scene for enemy groups
	[1, 20, 40]: [],
	[1, 40, 60]: [],
	[1, 60, 80]: [],
	[1, 80, 100]: [],
	[2, 0, 20]: [], # section 2
	[2, 20, 40]: [],
	[2, 40, 60]: [],
	[2, 60, 80]: [],
	[2, 80, 100]: [],
	[2, 0, 20]: [], # section 3
	[3, 20, 40]: [],
	[3, 40, 60]: [],
	[3, 60, 80]: [],
	[3, 80, 100]: [],
}

## The group of enemies currently being used
var current_enemy_group: EnemyGroup

func choose_enemy_group() -> PackedScene:
	return null #TODO go search for each enemy scene depending

