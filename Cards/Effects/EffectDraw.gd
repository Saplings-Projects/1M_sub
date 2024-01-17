class_name EffectDraw extends EffectBase

# @Override
@warning_ignore("unused_parameter")
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
    CardManager.card_container.draw_cards(value)
