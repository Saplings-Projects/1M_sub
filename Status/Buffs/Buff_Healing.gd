extends BuffBase
class_name Buff_Healing

func _init() -> void:
    is_stat_modification = true
    is_on_apply = true
    modifier_name = GlobalEnums.PossibleModifierNames.HEAL
    EntityStatDictType = GlobalEnums.EntityStatDictType.OFFENSE
    
    
## Default healing buff which adds 1 to the heal stat
static func default() -> BuffBase:
    var buff: Buff_Healing = Buff_Healing.new()
    var stat_modifier : StatModifiers = StatModifiers.new()
    stat_modifier.temporary_add = 1
    stat_modifier.ready()
    buff.status_modifier_base_value = stat_modifier
    return buff