class_name EffectDamage extends EffectBase

# @Override
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	var target_damage_data: DealDamageData = DealDamageData.new()
	# calculate modified damage given caster and target stats

	target_damage_data.damage = EntityStats.calculate_value_modified_by_stats(GlobalVar.POSSIBLE_MODIFIER_NAMES.DAMAGE, caster, target, value)
	target_damage_data.caster = caster # is this useful now that we calculate the stats before anyway ?
	target.get_health_component().deal_damage(target_damage_data)
