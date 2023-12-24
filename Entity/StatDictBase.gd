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