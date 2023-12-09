extends BuffBase
class_name Buff_Poison
## Poison deals damage to the owning Entity at the start of their turn

# @Override
func on_turn_start() -> void:
	var damage_data: DealDamageData = DealDamageData.new()
	damage_data.damage = buff_power
	damage_data.caster = buff_applier
	damage_data.ignore_caster_buffs = true
	damage_data.ignore_target_buffs = true
	
	buff_owner.get_health_component().deal_damage(damage_data)
