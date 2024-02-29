class_name Buff_Poison_Duration extends BuffBase

# @Override

func _init() -> void:
    is_stat_modification = true
    is_on_apply = true
    modifier_name = GlobalEnums.POSSIBLE_MODIFIER_NAMES.POISON
    # one problem with this approach is that the POISON effect could have both
    # its duration and damage modified by the same modifier, which could lead to some problem
    # ? solution : make a modifier for poison duration and another for poison damage
    
# @Override

func init_status(in_caster:Entity,in_target:Entity) -> void:
    super.init_status(in_caster,in_target)
    entity_stat_dict_type = GlobalEnums.ENTITY_STAT_DICT_TYPE.OFFENSE