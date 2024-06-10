extends DebuffBase
class_name Debuff_Weakness
## Vulnerability debuff decreases the amount of damage that an Entity deals

## @Override
func _init() -> void:
	is_stat_modification = true
	is_on_apply = true
	modifier_name = GlobalEnums.PossibleModifierNames.DAMAGE
	EntityStatDictType = GlobalEnums.EntityStatDictType.OFFENSE
	
	
## Default weakness debuff which removes 1 to the attack stat
static func default() -> DebuffBase:
	var buff: Debuff_Weakness = Debuff_Weakness.new()
	var stat_modifier : StatModifiers = StatModifiers.new()
	stat_modifier.temporary_add = -1
	stat_modifier.ready()
	buff.status_modifier_base_value = stat_modifier
	return buff
