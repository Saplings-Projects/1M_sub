class_name EffectDraw extends EffectBase

# @Override
@warning_ignore("unused_parameter")
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
    var modified_value: int = calculate_value("draw", caster, target, value)
    CardManager.card_container.draw_cards(modified_value)
