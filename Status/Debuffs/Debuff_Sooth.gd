class_name Debuff_Sooth extends DebuffBase
## Reduce the target's ability to soothe others

## @Override
func _init() -> void:
	is_stat_modification = true
	is_on_apply = true
	modifier_name = GlobalEnums.PossibleModifierNames.SOOTH
	
## @Override
func init_status(in_caster: Entity, _in_target: Entity) -> void:
	super.init_status(in_caster, in_caster)
	EntityStatDictType = GlobalEnums.EntityStatDictType.OFFENSE