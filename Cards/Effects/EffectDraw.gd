class_name EffectDraw extends EffectBase

# @Override
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
    var modified_value: int = calculate_value(StatDictBase.POSSIBLE_MODIFIER_NAMES.draw, caster, target, value)
    CardManager.card_container.draw_cards(modified_value)
