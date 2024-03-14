extends DebuffBase
class_name Debuff_Weakness
## Vulnerability buff decreases the amount of damage that an Entity deals

# @Override
func _init() -> void:
	is_stat_modification = true
	is_on_apply = true
	modifier_name = GlobalEnums.PossibleModifierNames.DAMAGE

# @Override
func init_status(in_caster: Entity, in_target: Entity) -> void:
	super.init_status(in_caster,in_target)
	EntityStatDictType = GlobalEnums.EntityStatDictType.OFFENSE
