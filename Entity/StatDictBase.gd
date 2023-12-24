class_name StatDictBase extends Resource

# TODO move to a global const file (which is already being made in another PR, so I'm not creating in double for now)
const POSSIBLE_MODIFIERS: Array[String] = [
    "damage",
    "poison"
]

var stat_dict: Dictionary = {}

func _init() -> void:
    for possible_modifier in POSSIBLE_MODIFIERS:
        stat_dict[possible_modifier] = StatModifiers.new()