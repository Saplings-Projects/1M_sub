class_name EffectDamageAll extends EffectBase

func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	var target_damage_data: DealDamageData = DealDamageData.new()
	var party = target.get_party_component().party
	target_damage_data.damage = value
	target_damage_data.caster = caster
	for party_target in party:
		party_target.get_health_component().deal_damage(target_damage_data)
