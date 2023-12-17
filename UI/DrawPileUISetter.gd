extends CardPileUISetter
class_name DrawPileUISetter


# @Override
func _get_count() -> int:
	return CardManager.card_container.get_draw_pile_size()
