class_name EffectDraw extends EffectBase
## Draw one or more cards from the draw pile. [br]
##
## The value of the effect is the number of cards to draw. [br]
## If there are not enough cards in the draw pile, the effect will draw as many cards as possible. [br]
## The discard pile will then be shuffled into the draw pile, and the remaining cards will be drawn. [br]
## This continues until either all the cards are drawn, or the player hand is full. [br]
## Refer to [param max_hand_size] in [CardContainer] for the maximum number of cards that can be held in the player hand. [br]

## @Override [br]
## Refer to [EffectBase]
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	var modified_value: int = EntityStats.get_value_modified_by_stats(GlobalEnums.PossibleModifierNames.DRAW, caster, target, value)
	CardManager.card_container.draw_cards(modified_value)
