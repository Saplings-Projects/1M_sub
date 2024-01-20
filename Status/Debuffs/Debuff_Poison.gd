extends DebuffBase
class_name Debuff_Poison
## Poison deals damage to the target Entity at the start of their turn

# @Override
func _init() -> void:
	is_on_turn_start = true
	
# @Override

func init_status(in_caster: Entity, in_target: Entity) -> void:
	super.init_status(in_caster, in_target)
	status_turn_duration = EntityStats.get_value_modified_by_stats(	GlobalVar.POSSIBLE_MODIFIER_NAMES.POISON, 
																	in_caster, 
																	in_target, 
																	status_turn_duration)
	

# @Override
func on_turn_start() -> void:
	var damage_data: DealDamageData = DealDamageData.new()
	damage_data.damage = status_power
	damage_data.caster = status_caster
	
	status_target.get_health_component().deal_damage(damage_data)
