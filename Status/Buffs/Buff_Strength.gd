extends BuffBase
class_name Buff_Strength
## Strength buff increases an Entity's damage stat

## @Override
func _init() -> void:
	is_stat_modification = true
	is_on_apply = true
	modifier_name = GlobalEnums.PossibleModifierNames.DAMAGE
	EntityStatDictType = GlobalEnums.EntityStatDictType.OFFENSE
	

## Default strength buff which adds 1 to the damage stat
static func default() -> BuffBase:
	var buff: Buff_Strength = Buff_Strength.new()
	var stat_modifier : StatModifiers = StatModifiers.new()
	stat_modifier.temporary_add = 1
	stat_modifier.ready()
	buff.status_modifier_base_value = stat_modifier
	return buff
