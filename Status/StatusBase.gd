extends Resource
class_name StatusBase
## Base status resource
##
## If you want to make a new status, create a child of this.
## If the status applies some sort of instant effect (eg poison), you can use an
## event function like on_turn_end.
## If the status applies persistent changes to the Entity's stats (eg strength), make changes to
## the stats in get_modified_stats.
## Put status in either buff or debuff folder depending on its effect


@export var infinite_duration: bool = false
@export var status_turn_duration: int = 3
@export var status_power: float = 1.0


var status_target: Entity = null
var status_caster: Entity = null

var is_on_apply: bool = false
# assuming that status are not on_apply and on_turn_start for now
# ie they don't have an effect at the start and also every turn
var status_modifier: StatModifiers = null
# this is only useful for status that modify stats


func init_status(in_caster: Entity, in_target: Entity) -> void:
	status_caster = in_caster
	status_target = in_target

func on_apply() -> void:
	var modifier_name: int = _return_modifier_name()
	var offense_modifier: StatModifiers = status_caster.get_stat_component().get_stats().offense_modifier_dict.stat_dict[modifier_name]
	var target_stats: EntityStats = status_target.get_stat_component().get_stats()
	var defense_modifier: StatModifiers = target_stats.defense_modifier_dict.stat_dict[modifier_name]
	var new_modification: StatModifiers = _calculate_new_modification(offense_modifier, defense_modifier)
	var targeted_modifier_dict = _return_targeted_modifier_dict()
	target_stats.change_stat(targeted_modifier_dict, modifier_name, new_modification)
	status_modifier = new_modification # store the value to revert when using on_remove()


func _calculate_new_modification(offense_modifier: StatModifiers, defense_modifier: StatModifiers) -> StatModifiers:
	# TODO check if this works for a self cast (we don't want to defend against ourselves)
	var new_modification: StatModifiers = StatModifiers.new()
	new_modification["permanent_add"] = offense_modifier["permanent_add"] - defense_modifier["permanent_add"]
	new_modification["permanent_multiply"] = offense_modifier["permanent_multiply"] / defense_modifier["permanent_multiply"]
	new_modification["temporary_add"] = offense_modifier["temporary_add"] - defense_modifier["temporary_add"]
	new_modification["temporary_multiply"] = offense_modifier["temporary_multiply"] / defense_modifier["temporary_multiply"]
	# assuming that a better defense means a positive value for the add and value greater than 1 for the multiply

	return new_modification

# To be overriden by the status children which say which stat they are influencing
func _return_modifier_name() -> int:
	return -1

# To be overriden by the status children which say which dictionary they influence (offense or defense)
# for example, a buff strength affects the offense dictionary. A debuff vulnerability affects the defense
func _return_targeted_modifier_dict() -> StatDictBase:
	var modifier_dict: StatDictBase = StatDictBase.new()
	return modifier_dict

func _calculate_invert_modification(modifier: StatModifiers) -> StatModifiers:
	var invert_modification: StatModifiers = StatModifiers.new()
	invert_modification["permanent_add"] = -modifier["permanent_add"]
	invert_modification["permanent_multiply"] = 1 / modifier["permanent_multiply"]
	invert_modification["temporary_add"] = -modifier["temporary_add"]
	invert_modification["temporary_multiply"] = 1 / modifier["temporary_multiply"]

	return invert_modification
	

func on_remove() -> void:
	var modifier_name: int = _return_modifier_name()
	var targeted_modifier_dict = _return_targeted_modifier_dict()
	var target_stats: EntityStats = status_target.get_stat_component().get_stats()
	var invert_modification: StatModifiers = _calculate_invert_modification(status_modifier)
	target_stats.change_stat(targeted_modifier_dict, modifier_name, invert_modification)
	status_modifier = null # reset to original state

func on_turn_start() -> void:
	pass


# other event examples:
# on_take_damage (eg: thorns effect)
# on_application (eg: shield)
# on_card_drawn
