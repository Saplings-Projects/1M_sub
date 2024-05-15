class_name Buff_Sooth extends BuffBase
## Increases the target's ability to soothe others

## @Override
func _init() -> void:
	is_stat_modification = true
	is_on_apply = true
	modifier_name = GlobalEnums.PossibleModifierNames.SOOTH
	
## @Override
func init_status(in_caster: Entity, in_target: Entity) -> void:
	super.init_status(in_caster, in_target)
	EntityStatDictType = GlobalEnums.EntityStatDictType.OFFENSE