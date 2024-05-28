extends Node
## Global node to manage the XP of the player
##
## This will count the XP of the player, update it when enemies are calmed 
## and give buffs at combat start depending on the level of the XP bar that was reached

## Current XP of the player
var current_xp: int = 0;
		

## Number of XP point to gather for each level, andd the related buff to apply [br]
## @experimental The buffs will most certainly change to become with infinite duration
@export var xp_levels: Array = [
	[5, Buff_Strength.new()],
	[12, Buff_Healing.new()], 
	[22, Buff_Poison_Duration.new()], 
	[37, Buff_Sooth.new()],
	]

## Add one to the XP (default to one, could be more for mini-bosses or bosses)
func increase(amount: int = 1) -> void:
	if amount >= 1:
		current_xp += amount
	else:
		push_warning("Tried to modify the XP with a negative or zero value, amount was: %s" % amount)
	

## Returns the list of buffs to be applied to the player at the start of a combat,
## depending on [param current_xp]
func get_buff_list() -> Array[BuffBase]:
	var buff_list: Array[BuffBase] = []
	for level: Array in xp_levels:
		if current_xp >= level[0]:
			var buff: BuffBase = level[1].duplicate()
			buff_list.append(buff)
	return buff_list
