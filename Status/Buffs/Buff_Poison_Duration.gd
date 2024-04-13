class_name Buff_Poison_Duration extends BuffBase
## Buff the ability of the target to apply longer poison effects
##
## ie when the target applies poison effects, the duration is boosted

## @Override
func _init() -> void:
    is_stat_modification = true
    is_on_apply = true
    modifier_name = GlobalEnums.PossibleModifierNames.POISON
    # one problem with this approach is that the POISON effect could have both
    # its duration and damage modified by the same modifier, which could lead to some problem
    # TODO solution : make a modifier for poison duration and another for poison damage
    
## @Override
func init_status(in_caster:Entity,in_target:Entity) -> void:
    super.init_status(in_caster,in_target)
    EntityStatDictType = GlobalEnums.EntityStatDictType.OFFENSE