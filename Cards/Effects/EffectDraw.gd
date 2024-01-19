class_name EffectDraw extends EffectBase

# @Override
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
    var modified_value: int = EntityStats.calculate_value_modified_by_stats(GlobalVar.POSSIBLE_MODIFIER_NAMES.DRAW, caster, target, value)
    CardManager.card_container.draw_cards(modified_value)
