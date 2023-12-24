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

var buff_count: int = 0
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

var damage_dealt_increase: float = 0
var damage_taken_increase: float = 0
