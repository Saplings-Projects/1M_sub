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

func change_modifier_of_given_name( name: String,
                                    add_to_perm: int = 0, 
                                    mult_to_perm: float = 1, 
                                    add_to_temp: int = 0, 
                                    mult_to_temp: float = 1
                                    ) -> void:
    # the different int / float values should be the value of the effect, not the total amount you want
    # for example, if you have a card that adds 3 damage for 3 turns and also raises it by 20% then you should call:
    # change_modifier("damage", 0, 1, 3, 1.2)
    # since there are default values, alternatively you can do: change_modifier("damage", add_to_temp=3, mult_to_temp=1.2)
    # this is actually the prefered way, since it's more readable and also less error prone (imagine if you multiply by 0 when you wanted to add 0)

    # TODO move this previous comment to the docs ? a simplified version ?
    stat_dict[name].change_modifier(add_to_perm, mult_to_perm, add_to_temp, mult_to_temp)

