extends BuffBase
class_name Buff_Healing

func _init() -> void:
    is_stat_modification = true
    is_on_apply = true
    modifier_name = GlobalEnums.PossibleModifierNames.HEAL

func init_status(in_caster: Entity, in_target: Entity) -> void:
    super.init_status(in_caster, in_target)
    EntityStatDictType = GlobalEnums.EntityStatDictType.OFFENSE