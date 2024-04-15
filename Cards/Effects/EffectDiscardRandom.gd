class_name EffectDiscardRandom extends EffectBase
## Discard a random card from the player's hand.
##
## This is often used as a penalty effect / side effect of a powerful card.

## @Override [br]
## Refer to [EffectBase]
@warning_ignore("unused_parameter")
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	CardManager.card_container.discard_random_card(value)
