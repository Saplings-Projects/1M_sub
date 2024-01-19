extends BuffBase
class_name Buff_Strength
## Strength buff increases an Entity's damage stat

# @Override
func _init() -> void:
	is_stat_modification = true
	is_on_apply = true
	modifier_name = GlobalVar.POSSIBLE_MODIFIER_NAMES.DAMAGE

# @Override
func init_status(in_caster: Entity, in_target: Entity) -> void:
	status_caster = in_caster
	status_target = in_target
	entity_stat_dict_type = GlobalVar.ENTITY_STAT_DICT_TYPE.OFFENSE
