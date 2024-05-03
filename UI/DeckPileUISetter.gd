extends CardPileUISetter
class_name DeckPileUISetter
## A type of card pile, used only for showing the complete deck of cards.

## The parent is different from the other card piles, since this particular card pile is part of an overlay [br]
## This means the scene it needs to be instantiated in is not the overlay directly (which would be the parent), but the scene that contains the overlay. [br]
func _ready() -> void:
	super()
	parent = $"../.."

# @override
func _on_card_counts_updated() -> void:
	pass
