extends DebuffBase
class_name Debuff_Healing
## reduces the target's ability to heal itself

## @Override
func _init() -> void:
	is_stat_modification = true
	is_on_apply = true
	modifier_name = GlobalEnums.PossibleModifierNames.HEAL
	EntityStatDictType = GlobalEnums.EntityStatDictType.OFFENSE

	
## Default healing debuff which removes 1 to the heal stat
static func default() -> DebuffBase:
	var buff: Debuff_Healing = Debuff_Healing.new()
	var stat_modifier : StatModifiers = StatModifiers.new()
	stat_modifier.temporary_add = -1
	stat_modifier.ready()
	buff.status_modifier_base_value = stat_modifier
	return buff