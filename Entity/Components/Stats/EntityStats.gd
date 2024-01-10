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
var offense_modifier_dict: StatDictBase = null
var defense_modifier_dict: StatDictBase = null

func _init() -> void:
    offense_modifier_dict = StatDictBase.new()
    defense_modifier_dict = StatDictBase.new()

# to trigger on the combat end signal, do we have one yet ?
# do we even have a condition for the end of a combat ?
func reset_modifier_dict_temp_to_default() -> void:
    offense_modifier_dict.reset_all_temp_to_default()
    defense_modifier_dict.reset_all_temp_to_default()

func change_stat(   modifier_dict: StatDictBase, 
                    enum_name: int,
                    new_modification: StatModifiers
                    ) -> void:
    modifier_dict.change_modifier_of_given_name(enum_name, new_modification)
    modification_count += 1

func _calculate_modified_value_offense(enum_name: int, base_value: int) -> int:
    var modified_value: int = base_value
    var modifier: StatModifiers = offense_modifier_dict.stat_dict[enum_name]
    modified_value += modifier.add_to_temp
    modified_value += modifier.add_to_permanent
    modified_value *= modifier.mult_to_temp
    modified_value *= modifier.mult_to_permanent
    # a problem with this approach is that the heal which uses a negative value
    # won't work anymore (we will basically reduce the heal instead of increasing it)
    # this is only a problem with the heal, so I think the problem should be dealt with in the heal effect

    return ceil(modified_value)

func _calculate_modified_value_defense(enum_name: int, base_value: int) -> int:
    var modified_value: int = base_value
    var modifier: StatModifiers = defense_modifier_dict.stat_dict[enum_name]
    modified_value -= modifier.add_to_temp
    modified_value -= modifier.add_to_permanent
    modified_value /= modifier.mult_to_temp
    modified_value /= modifier.mult_to_permanent

    return ceil(modified_value)

func calculate_modified_value(enum_name: int, base_value: int, is_offense: bool) -> int:
    if is_offense:
        return _calculate_modified_value_offense(enum_name, base_value)
    else:
        return _calculate_modified_value_defense(enum_name, base_value)
