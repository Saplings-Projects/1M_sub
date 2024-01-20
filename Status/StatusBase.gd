extends Resource
class_name StatusBase
## Base status resource
##
## If you want to make a new status, create a child of this.
## If the status applies some sort of instant effect (eg poison), you can use an
## event function like on_turn_end.
## If the status applies persistent changes to the Entity's stats (eg strength), make changes to
## the stats in get_modified_stats.
## Put status in either buff or debuff folder depending on its effect


@export var infinite_duration: bool = false
@export var status_turn_duration: int = 3
@export var status_power: float = 1.0
@export var status_modifier_base_value: StatModifiers = null

var is_stat_modification: bool = false
var is_on_apply: bool = false
var is_on_turn_start: bool = false
# assuming that status are not on_apply and on_turn_start for now
# ie they don't have an effect at the start and also every turn

var status_target: Entity = null
var status_caster: Entity = null

var status_modifier_storage: StatModifiers = null
var modifier_name: int = -1 # to be overriden by the status children
var entity_stat_dict_type: GlobalVar.ENTITY_STAT_DICT_TYPE # to be overriden by the status children
# this is only useful for status that modify stats

func _init() -> void:
	pass

func init_status(in_caster: Entity, in_target: Entity) -> void:
	status_caster = in_caster
	status_target = in_target
	# status that change stat have to override this to set targeted_modifier_dict
	# since it depends on the target, it can't be set in the _init()

func on_apply() -> void:
	if is_stat_modification:
		_modify_stats_with_status()
	else:
		pass
		# TODO is there a status that is_on_apply but doesn't modify stats ?
		# what do we do for a Status that reflects a part of the damage for example ?

func _modify_stats_with_status() -> void:
	var target_stats: EntityStats = status_target.get_stat_component().get_stats()
	target_stats.change_stat(entity_stat_dict_type, modifier_name, status_modifier_base_value)
	status_modifier_storage = status_modifier_base_value # store the value to revert when using on_remove()


func _calculate_invert_modification(modifier: StatModifiers) -> StatModifiers:
	var invert_modification: StatModifiers = StatModifiers.new()
	var _MODIFIER_KEYS: Dictionary = GlobalVar.MODIFIER_KEYS
	var modifier_base_dict: Dictionary = modifier.modifier_base_dict
	invert_modification.modifier_base_dict[_MODIFIER_KEYS.PERMANENT_ADD] = -modifier_base_dict[_MODIFIER_KEYS.PERMANENT_ADD]
	invert_modification.modifier_base_dict[_MODIFIER_KEYS.PERMANENT_MULTIPLY] = 1 / modifier_base_dict[_MODIFIER_KEYS.PERMANENT_MULTIPLY]
	invert_modification.modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_ADD] = -modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_ADD]
	invert_modification.modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_MULTIPLY] = 1 / modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_MULTIPLY]

	return invert_modification
	

func on_remove() -> void:
	if is_stat_modification:
		_revert_stats_with_status()
	else:
		pass

func _revert_stats_with_status() -> void:
	var target_stats: EntityStats = status_target.get_stat_component().get_stats()
	var invert_modification: StatModifiers = _calculate_invert_modification(status_modifier_storage)
	target_stats.change_stat(entity_stat_dict_type, modifier_name, invert_modification)
	status_modifier_storage = null # reset to original state

func on_turn_start() -> void:
	pass


# other event examples:
# on_take_damage (eg: thorns effect)
# on_application (eg: shield)
# on_card_drawn
