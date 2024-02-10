class_name EffectDamage extends EffectBase

# @Override
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	# calculate modified damage given caster and target stats
	var damage = EntityStats.get_value_modified_by_stats(GlobalVar.POSSIBLE_MODIFIER_NAMES.DAMAGE, caster, target, value)
	
	target.get_health_component().deal_damage(damage, caster)

