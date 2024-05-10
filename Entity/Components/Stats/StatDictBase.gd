class_name StatDictBase extends Resource
## A class that holds a dictionary of [StatModifiers]
##
## This allows to modify all the stats of a character in a single place

## to add a new modifier/stat, you need to:
##	Add a new entry in the [enum GlobalEnums.PossibleModifierNames]

## The dictionary of [StatModifiers]
var stat_dict: Dictionary = {}

## Build the dictionary of [StatModifiers] [br]
## For all the possible modifier names, make a new [StatModifiers] and add it to the dictionary [br]
## See [enum GlobalEnums.PossibleModifierNames] for the possible modifier names [br]
func _init() -> void:
	for modifier_name_index: int in GlobalEnums.PossibleModifierNames.values():
		stat_dict[modifier_name_index] = StatModifiers.new()

## Reset all the temporary keys of each modifier to its default value [br]
func reset_all_temp_to_default() -> void:
	for modifier_name: int in GlobalEnums.PossibleModifierNames.values():
		stat_dict[modifier_name].reset_temp_to_default()

## Wrapper around [method StatModifiers.change_modifier] [br]
func change_modifier_of_given_name( modifier_name: GlobalEnums.PossibleModifierNames, new_modification: StatModifiers) -> void:
	# the different int / float values in new_modification should be the value of the effect, not the total amount you want
	# for example, if you have a card that adds 3 damage for 3 turns and also raises it by 20% then you should call:
	# With temporary_add=0, temporary_multiply=1, permanent_add=3, permanent_multiply=1.2

	# TODO move this previous comment to the docs ? a simplified version ?
	stat_dict[modifier_name].change_modifier(new_modification)


## This function is only used to setup the dictionary in tests [br]
## In play, the tree logic will already properly setup everything [br]
## an alternative is to call ready in the _init of this class
## but it would mean that ready is called twice on the stat_modifiers (once here and once due to the tree)
## @experimental
func ready_stat_dict() -> void:
	for modifer_name_index: int in GlobalEnums.PossibleModifierNames.values():
		stat_dict[modifer_name_index].ready()
