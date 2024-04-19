extends CardPileUISetter
class_name DeckPileUISetter

func _ready() -> void:
	super()
	parent = $"../.."

# @override
func _on_card_counts_updated() -> void:
	pass
