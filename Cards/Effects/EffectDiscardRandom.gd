class_name EffectDiscardRandom extends EffectBase

# @Override
@warning_ignore("unused_parameter")
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
    CardManager.card_container.discard_random_card(value)
