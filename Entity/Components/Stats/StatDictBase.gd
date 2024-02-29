class_name StatDictBase extends Resource

var stat_dict: Dictionary = {} # is a dictionary of StatModifiers

func _init() -> void:
	for modifier_name_index: int in GlobalEnum.POSSIBLE_MODIFIER_NAMES.values():
		stat_dict[modifier_name_index] = StatModifiers.new()

# maybe the name could be a bit more unique compared to `reset_temp_to_default`?
# so we don't confuse them
func reset_all_temp_to_default() -> void:
	for modifier_name: int in GlobalEnum.POSSIBLE_MODIFIER_NAMES.values():
		stat_dict[modifier_name].reset_temp_to_default()

func change_modifier_of_given_name( modifier_name: GlobalEnum.POSSIBLE_MODIFIER_NAMES, new_modification: StatModifiers) -> void:
	# the different int / float values in new_modification should be the value of the effect, not the total amount you want
	# for example, if you have a card that adds 3 damage for 3 turns and also raises it by 20% then you should call:
	# With temporary_add=0, temporary_multiply=1, permanent_add=3, permanent_multiply=1.2

	# TODO move this previous comment to the docs ? a simplified version ?
	stat_dict[modifier_name].change_modifier(new_modification)


# This function is only used to setup the dictionary in tests
# In play, the tree logic will already properly setup everything
# an alternative is to call ready in the _init of this class
# but it would mean that ready is called twice on the stat_modifiers (once here and once due to the tree)
func ready_stat_dict() -> void:
	for modifer_name_index: int in GlobalEnum.POSSIBLE_MODIFIER_NAMES.values():
		stat_dict[modifer_name_index].ready()
