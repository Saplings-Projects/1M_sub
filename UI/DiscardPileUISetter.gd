extends CardPileUISetter
class_name DiscardPileUISetter


# @Override
func _get_count() -> int:
	return CardManager.card_container.get_discard_pile_size()
