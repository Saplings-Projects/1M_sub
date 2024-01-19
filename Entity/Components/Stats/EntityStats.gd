extends Resource
class_name EntityStats
## Used as a container for modified runtime stats of an Entity.
##
## Use StatComponent to get a reference to the current stats on the Entity.
## We can increase these stats with buffs, items, or equipment. We shouldn't modify the stats
## directly, but instead create a modified version of the stats whenever we need them. This is so
## we don't have to worry about reverting the state of the stats whenever the buff/item/equipment
## is removed. See get_modified_stats on BuffBase for an example.

## The previous statement will probably change, since we want to modify stats at runtime and we revert the changes when effects are removed.

var modification_count: int = 0
var _offense_modifier_dict: StatDictBase = null
var _defense_modifier_dict: StatDictBase = null

var _ENTITY_STAT_DICT_SELECTOR : Dictionary = {
	0: _offense_modifier_dict,
	1: _defense_modifier_dict,
}

# This structure allows to give the enum as a parameter to a function 
# and to call the correct dictionary via _ENTITY_STAT_DICT_SELECTOR.entity_stat_dict_type

func _init() -> void:
	_offense_modifier_dict = StatDictBase.new()
	_defense_modifier_dict = StatDictBase.new()
	
	# Update selector dictionary
	
	_ENTITY_STAT_DICT_SELECTOR[0] = _offense_modifier_dict
	_ENTITY_STAT_DICT_SELECTOR[1] = _defense_modifier_dict

# to trigger on the combat end signal, do we have one yet ?
# do we even have a condition for the end of a combat ?
func reset_modifier_dict_temp_to_default() -> void:
	_offense_modifier_dict.reset_all_temp_to_default()
	_defense_modifier_dict.reset_all_temp_to_default()

func change_stat(   entity_stat_dict_type: GlobalVar.ENTITY_STAT_DICT_TYPE, 
					modifier_name: GlobalVar.POSSIBLE_MODIFIER_NAMES,
					new_modification: StatModifiers
					) -> void:
	_ENTITY_STAT_DICT_SELECTOR[entity_stat_dict_type].change_modifier_of_given_name(modifier_name, new_modification)
	modification_count += 1

func _calculate_modified_value_offense(modifier_name: GlobalVar.POSSIBLE_MODIFIER_NAMES, base_value: int) -> int:
	var modified_value: int = base_value
	var modifier: Dictionary = _offense_modifier_dict.stat_dict[modifier_name].modifiers
	var MODIFIER_KEYS: Dictionary = GlobalVar.MODIFIER_KEYS
	modified_value += modifier[MODIFIER_KEYS.TEMPORARY_ADD]
	modified_value += modifier[MODIFIER_KEYS.PERMANENT_ADD]
	modified_value *= modifier[MODIFIER_KEYS.TEMPORARY_MULTIPLY]
	modified_value *= modifier[MODIFIER_KEYS.PERMANENT_MULTIPLY]
	# a problem with this approach is that the heal which uses a negative value
	# won't work anymore (we will basically reduce the heal instead of increasing it)
	# this is only a problem with the heal, so I think the problem should be dealt with in the heal effect

	return ceil(modified_value)

func _calculate_modified_value_defense(modifier_name: GlobalVar.POSSIBLE_MODIFIER_NAMES, base_value: int) -> int:
	var modified_value: int = base_value
	var modifier: Dictionary = _defense_modifier_dict.stat_dict[modifier_name].modifiers
	var MODIFIER_KEYS: Dictionary = GlobalVar.MODIFIER_KEYS
	modified_value -= modifier[MODIFIER_KEYS.TEMPORARY_ADD]
	modified_value -= modifier[MODIFIER_KEYS.PERMANENT_ADD]
	modified_value /= modifier[MODIFIER_KEYS.TEMPORARY_MULTIPLY]
	modified_value /= modifier[MODIFIER_KEYS.PERMANENT_MULTIPLY]

	return ceil(modified_value)

func calculate_modified_value(modifier_name: GlobalVar.POSSIBLE_MODIFIER_NAMES, base_value: int, is_offense: bool) -> int:
	if is_offense:
		return _calculate_modified_value_offense(modifier_name, base_value)
	else:
		return _calculate_modified_value_defense(modifier_name, base_value)
