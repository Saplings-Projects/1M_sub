extends DebuffBase
class_name Debuff_Weakness
## Vulnerability buff decreases the amount of damage that an Entity deals

# @Override
func _return_modifier_name() -> int:
	return StatDictBase.POSSIBLE_MODIFIER_NAMES.damage

# @Override
func _return_targeted_modifier_dict() -> StatDictBase:
	return status_target.get_stat_component().get_stats().offense_modifier_dict
