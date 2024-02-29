extends BuffBase
class_name Buff_Strength
## Strength buff increases an Entity's damage stat

# @Override
func _init() -> void:
	is_stat_modification = true
	is_on_apply = true
	modifier_name = GlobalEnums.POSSIBLE_MODIFIER_NAMES.DAMAGE

# @Override
func init_status(in_caster: Entity, in_target: Entity) -> void:
	super.init_status(in_caster,in_target)
	entity_stat_dict_type = GlobalEnums.ENTITY_STAT_DICT_TYPE.OFFENSE
