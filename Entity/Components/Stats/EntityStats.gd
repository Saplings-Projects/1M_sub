extends Resource
class_name EntityStats
## Used as a container for modified runtime stats of an Entity.
##
## Use StatComponent to get a reference to the current stats on the Entity. [br]
## We can modify these stats with status (buff / debuff) or items among other things. [br]

## The number of times the stats have been modified. [br]
## This decreases if the stat modification is reverted.
var modification_count: int = 0
## The dictionary of stats for the offense of the character.
var _offense_modifier_dict: StatDictBase = null
## The dictionary of stats for the defense of the character.
var _defense_modifier_dict: StatDictBase = null

## Used to select the correct dictionary based on [enum GlobalEnums.EntityStatDictType]. [br]
## This is used to be able to select a dictionary based on the type of stat we want to modify, while keeping strong typing.
var _ENTITY_STAT_DICT_SELECTOR : Dictionary = {
	0: _offense_modifier_dict,
	1: _defense_modifier_dict,
}
# ! Don't forget to update EntityStatDictType in GLobal_Enums.gd if you modify this

## Create the dictionaries for the stats.
func _init() -> void:
	_offense_modifier_dict = StatDictBase.new()
	_defense_modifier_dict = StatDictBase.new()
	
	# Update selector dictionary
	
	_ENTITY_STAT_DICT_SELECTOR[0] = _offense_modifier_dict
	_ENTITY_STAT_DICT_SELECTOR[1] = _defense_modifier_dict

## Reset all the temporary stats in both offense and defense dictionaries. [br]
## ? To trigger on the combat end signal, do we have one yet [br]
## ? Do we even have a condition for the end of a combat [br]
func reset_modifier_dict_temp_to_default() -> void:
	_offense_modifier_dict.reset_all_temp_to_default()
	_defense_modifier_dict.reset_all_temp_to_default()


## Wrapper around [method StatDictBase.change_modifier_of_given_name] [br]
## It chooses the dictionnary and changes the given modifier with the new modification. [br]
func change_stat(   EntityStatDictType: GlobalEnums.EntityStatDictType, 
					modifier_name: GlobalEnums.PossibleModifierNames,
					new_modification: StatModifiers
					) -> void:
	# TODO add boolean for add or remove stat (to know to increase or decrease the modification count)
	_ENTITY_STAT_DICT_SELECTOR[EntityStatDictType].change_modifier_of_given_name(modifier_name, new_modification)
	modification_count += 1

## Calculate the modified value based on the base value and the modifiers of offense. [br]
## Calculation is done as follows: (base_value + temporary_add + permanent_add) * temporary_multiply * permanent_multiply [br]
## Rounded up if not an integer. [br]
## This makes sense because if we have an offense of 1 on the add, then we expect to deal one more damage meaning we add [br]
## In the same way, if we have a two times better offense on the multiply, we expect to deal twice the damage, so we multiply.
func _calculate_modified_value_offense(modifier_name: GlobalEnums.PossibleModifierNames, base_value: int) -> int:
	var modified_value: int = base_value
	var modifier_base_dict: Dictionary = _offense_modifier_dict.stat_dict[modifier_name].modifier_base_dict
	var MODIFIER_KEYS: Dictionary = GlobalVar.MODIFIER_KEYS
	modified_value += modifier_base_dict[MODIFIER_KEYS.TEMPORARY_ADD]
	modified_value += modifier_base_dict[MODIFIER_KEYS.PERMANENT_ADD]
	modified_value *= modifier_base_dict[MODIFIER_KEYS.TEMPORARY_MULTIPLY]
	modified_value *= modifier_base_dict[MODIFIER_KEYS.PERMANENT_MULTIPLY]
	# TODO a problem with this approach is that the heal which uses a negative value
	# won't work anymore (we will basically reduce the heal instead of increasing it)
	# this is only a problem with the heal, so I think the problem should be dealt with in the heal effect
	# TODO maybe change order of operations (multiply first, then add) ?

	return ceil(modified_value)

## Calculate the modified value based on the base value and the modifiers of defense. [br]
## Calculation is done as follows: (base_value - temporary_add - permanent_add) / (temporary_multiply * permanent_multiply) [br]
## Rounded up if not an integer. [br]
## This makes sense because if we have a defense of 1 on the add, then we expect to take one less damage meaning we substract [br]
## In the same way, if we have a two times better on the multiply, we expect to take half the damage, so we divide.
func _calculate_modified_value_defense(modifier_name: GlobalEnums.PossibleModifierNames, base_value: int) -> int:
	var modified_value: int = base_value
	var modifier_base_dict: Dictionary = _defense_modifier_dict.stat_dict[modifier_name].modifier_base_dict
	var MODIFIER_KEYS: Dictionary = GlobalVar.MODIFIER_KEYS
	modified_value -= modifier_base_dict[MODIFIER_KEYS.TEMPORARY_ADD]
	modified_value -= modifier_base_dict[MODIFIER_KEYS.PERMANENT_ADD]
	modified_value /= modifier_base_dict[MODIFIER_KEYS.TEMPORARY_MULTIPLY]
	modified_value /= modifier_base_dict[MODIFIER_KEYS.PERMANENT_MULTIPLY]

	return ceil(modified_value)
	
## Calculate the modifided value based on the base value and the modifiers of offense and defense. [br]
## Calulation is done as follows: base value + offense of caster - defense of target [br]
## This makes sense, because if we have a base value of 10, caster has an offense of 2 and a target a defense of 1, we expect to deal 11 damage: [br]
## 10 + 2 - 1 = 11 damage [br]
## In the same way, if the caster has worse attack (a penalty of 2 on the attack stat, ie a -2) and the target has a worse defense too (a penalty of -1 on the defense) we get: [br]
## 10 + (-2) - (-1) = 10 -2 + 1 = 9 damage [br]
static func get_value_modified_by_stats(modifier_name: GlobalEnums.PossibleModifierNames, caster: Entity, target: Entity, value: int) -> int:
	var modified_value: int = value
	var caster_stats: EntityStats = null
	if caster != null:
		caster_stats = caster.get_stat_component().stats
		modified_value = caster_stats._calculate_modified_value_offense(modifier_name, modified_value)

	var target_stats: EntityStats = null
	if target != null:
		target_stats = target.get_stat_component().stats
		modified_value = target_stats._calculate_modified_value_defense(modifier_name, modified_value) 

	return modified_value


## This function is only used to setup the dictionary in tests
## In play, the tree logic will already properly setup everything
## @experimental
func ready_entity_stats() -> void:
	_offense_modifier_dict.ready_stat_dict()
	_defense_modifier_dict.ready_stat_dict()
