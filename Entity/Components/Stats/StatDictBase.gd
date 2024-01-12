class_name StatDictBase extends Resource

# TODO move to a global const file (which is already being made in another PR (#30), so I'm not creating in double for now)
enum POSSIBLE_MODIFIER_NAMES {
	damage,
	poison,
	draw,
	card_reward_number
}

var stat_dict: Dictionary = {} # is a dictionary of StatModifiers

func _init() -> void:
	for enum_name_index: int in POSSIBLE_MODIFIER_NAMES.values():
		stat_dict[enum_name_index] = StatModifiers.new()

# maybe the name could be a bit more unique compared to `reset_temp_to_default`?
# so we don't confuse them
func reset_all_temp_to_default() -> void:
	for enum_name in POSSIBLE_MODIFIER_NAMES.values():
		stat_dict[enum_name].reset_temp_to_default()

func change_modifier_of_given_name( enum_name: int, new_modification: StatModifiers) -> void:
	# the different int / float values in new_modification should be the value of the effect, not the total amount you want
	# for example, if you have a card that adds 3 damage for 3 turns and also raises it by 20% then you should call:
	# With temporary_add=0, temporary_multiply=1, permanent_add=3, permanent_multiply=1.2

	# TODO move this previous comment to the docs ? a simplified version ?
	stat_dict[enum_name].change_modifier(new_modification)
