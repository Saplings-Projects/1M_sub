extends DebuffBase
class_name Debuff_Healing
## reduces the target's ability to heal itself

## @Override
func _init() -> void:
	is_on_turn_start = true
	is_on_apply = true
	modifier_name = GlobalEnums.PossibleModifierNames.HEAL
	
## @Override
func init_status(in_caster: Entity, _in_target: Entity) -> void:
	super.init_status(in_caster, in_caster)
	EntityStatDictType = GlobalEnums.EntityStatDictType.OFFENSE

	
