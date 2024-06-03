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
    EntityStatDictType = GlobalEnums.EntityStatDictType.OFFENSE
    
## Default poison duration buff which adds 1 to the poison stat
static func default() -> BuffBase:
    var buff: Buff_Poison_Duration = Buff_Poison_Duration.new()
    var stat_modifier : StatModifiers = StatModifiers.new()
    stat_modifier.temporary_add = 1
    stat_modifier.ready()
    buff.status_modifier_base_value = stat_modifier
    return buff
    