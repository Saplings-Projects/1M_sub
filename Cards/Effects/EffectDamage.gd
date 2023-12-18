class_name EffectDamage extends EffectBase

# @Override
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
    var target_damage_data: DealDamageData = DealDamageData.new()
    target_damage_data.damage = value
    target_damage_data.caster = caster
    target.get_health_component().deal_damage(target_damage_data)

# TODO : what to do for Status that inflige damage over time ?
    # Should they call an EffectDamage when they trigger each turn ?
    # or should they directly call deal_damage on the target ?
