extends DebuffBase
class_name Debuff_Poison
## Poison deals damage to the owning Entity at the start of their turn

# @Override
func on_turn_start() -> void:
	var damage_data: DealDamageData = DealDamageData.new()
	damage_data.damage = status_power
	damage_data.caster = status_applier
	damage_data.ignore_caster_status = true
	damage_data.ignore_target_status = true
	
	status_owner.get_health_component().deal_damage(damage_data)
