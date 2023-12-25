class_name StatDictBase extends Resource

# TODO move to a global const file (which is already being made in another PR (#30), so I'm not creating in double for now)
const POSSIBLE_MODIFIERS: Array[String] = [
    "damage",
    "poison",
    "draw",
    "card_reward_number"
]

var stat_dict: Dictionary = {} # is a dictionary of StatModifiers

func _init() -> void:
    for possible_modifier in POSSIBLE_MODIFIERS:
        stat_dict[possible_modifier] = StatModifiers.new()

# maybe the name could be a bit more unique compared to `reset_temp_to_default`?
# so we don't confuse them
func reset_all_temp_to_default() -> void:
    for possible_modifier in POSSIBLE_MODIFIERS:
        stat_dict[possible_modifier].reset_temp_to_default()

func change_modifier_of_given_name( name: String, new_modification: StatModifiers) -> void:
    # the different int / float values in new_modification should be the value of the effect, not the total amount you want
    # for example, if you have a card that adds 3 damage for 3 turns and also raises it by 20% then you should call:
    # With add_to_temp=0, mult_to_temp=1, add_to_permanent=3, mult_to_permanent=1.2

    # TODO move this previous comment to the docs ? a simplified version ?
    stat_dict[name].change_modifier(new_modification)

