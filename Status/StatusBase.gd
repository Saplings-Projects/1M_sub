extends Resource
class_name StatusBase
## Base of all status (buffs and debuffs) in the game.
##
## If you want to make a new status, create a child of either buff or debuff (which are themselves child of StatusBase) [br]
## Put status in either buff or debuff folder depending on its effect [br]
## If the status applies some sort of instant effect (eg poison), you can use an
## event function like on_turn_start [br]

## To know if the status needs to decrease the remaining number of turns each turn
@export var infinite_duration: bool = false
## The number of turns the status will last
@export var status_turn_duration: int = 3
## The power of the status (for example a power of 3 on Poison means you take 3 poison damage per turn)
@export var status_power: float = 1.0
## Used only for status that modify stats
@export var status_modifier_base_value: StatModifiers = null

## Know if the status modifies stats or not
var is_stat_modification: bool = false
## Know if the status has an effect when applied
var is_on_apply: bool = false
## Know if the status has an effect at the start of the turn
var is_on_turn_start: bool = false
# assuming that status are not on_apply and on_turn_start for now
# ie they don't have an effect at the start and also every turn

## The entity that will receive the status
var status_target: Entity = null
## The entity that applied the status
var status_caster: Entity = null

## The value of the modifier that will be applied to the target [br]
## Is stored in order to be able to revert later on [br]
## @experimental
## This might be changed later to instead directly calculate the inverse of the modifier
var status_modifier_storage: StatModifiers = null
## The thing you want to modify (damage, poison, draw, etc.)
var modifier_name: int = -1 # to be overriden by the status children
## If you want to modify the offense or the defense [br]
## Only useful for status that modify stats
var EntityStatDictType: GlobalEnums.EntityStatDictType # to be overriden by the status children
# this is only useful for status that modify stats

## To be overriden by the status children
func _init() -> void:
	pass

## Initialize the status with the caster and the target [br]
## Since it depends on the target, it can't be set in the _init() [br]
## Status that change stat have to override this to set targeted_modifier_dict
func init_status(in_caster: Entity, in_target: Entity) -> void:
	status_caster = in_caster
	status_target = in_target
	
## Trigger the effect of a status that does something when applied
func on_apply() -> void:
	if is_stat_modification:
		_modify_stats_with_status()
	else:
		pass
		# TODO is there a status that is_on_apply but doesn't modify stats ?
		# what do we do for a Status that reflects a part of the damage for example ?

## Modify the stats of the target with the status
func _modify_stats_with_status() -> void:
	var target_stats: EntityStats = status_target.get_stat_component().stats
	target_stats.change_stat(EntityStatDictType, modifier_name, status_modifier_base_value)
	status_modifier_storage = status_modifier_base_value # store the value to revert when using on_remove()


## Calculate the inverse of the modifier to revert the modification
func _calculate_invert_modification(modifier: StatModifiers) -> StatModifiers:
	var invert_modification: StatModifiers = StatModifiers.new()
	invert_modification.ready()
	var _MODIFIER_KEYS: Dictionary = GlobalVar.MODIFIER_KEYS
	var modifier_base_dict: Dictionary = modifier.modifier_base_dict
	invert_modification.modifier_base_dict[_MODIFIER_KEYS.PERMANENT_ADD] = -modifier_base_dict[_MODIFIER_KEYS.PERMANENT_ADD]
	invert_modification.modifier_base_dict[_MODIFIER_KEYS.PERMANENT_MULTIPLY] = 1 / modifier_base_dict[_MODIFIER_KEYS.PERMANENT_MULTIPLY]
	invert_modification.modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_ADD] = -modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_ADD]
	invert_modification.modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_MULTIPLY] = 1 / modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_MULTIPLY]

	return invert_modification
	

## Actions to be done when a status is removed from an entity
## For now, it just reverts the stats modification
func on_remove() -> void:
	if is_stat_modification:
		_revert_stats_with_status()
	else:
		pass

## Revert the stats modification of the entity
func _revert_stats_with_status() -> void:
	var target_stats: EntityStats = status_target.get_stat_component().stats
	var invert_modification: StatModifiers = _calculate_invert_modification(status_modifier_storage)
	target_stats.change_stat(EntityStatDictType, modifier_name, invert_modification)
	status_modifier_storage = null # reset to original state

## Actions to be done at the start of a turn [br]
## To be overriden by the status children
func on_turn_start() -> void:
	pass


# other event examples:
# on_take_damage (eg: thorns effect)
# on_application (eg: shield)
# on_card_drawn
# TODO make this using signals in child class instead
