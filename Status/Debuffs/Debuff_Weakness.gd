extends DebuffBase
class_name Debuff_Weakness
## Vulnerability buff decreases the amount of damage that an Entity deals

# @Override
func _init() -> void:
	is_stat_modification = true
	is_on_apply = true
	modifier_name = StatDictBase.POSSIBLE_MODIFIER_NAMES.damage

# @Override
func init_status(in_caster: Entity, in_target: Entity) -> void:
	status_caster = in_caster
	status_target = in_target
	targeted_modifier_dict = in_target.get_stat_component().get_stats().offense_modifier_dict
