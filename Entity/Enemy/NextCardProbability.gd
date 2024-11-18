class_name NextCardProbability extends Resource
## A class to hold the probability to get a given card played by an enemy

## Probability to play the associated card,
## this should be between 0 and 100
@export var probability: int = 0
## The card to be played
@export var card: CardBase = null

func _init(new_probability: int, new_card: CardBase) -> void:
	probability = new_probability
	card = new_card
