extends Node
## Global node to manage the XP of the player
##
## This will count the XP of the player, update it when enemies are calmed 
## and give buffs at combat start depending on the level of the XP bar that was reached

signal new_xp_level_reached

## Current XP of the player
var current_xp: int = 0

## Next amount of XP to reach to get the next buff
var next_xp_level: int

## The last amount of XP that gave a buff
var previous_xp_level: int	

var current_list_of_buffs: Array[BuffBase] = []

## Number of XP point to gather for each level, andd the related buff to apply [br]
## @experimental The buffs will most certainly change to become with infinite duration
@export var xp_levels: Dictionary = {
	5: 	["Strength", Buff_Strength.new()],
	12: ["Healing", Buff_Healing.new()], 
	22: ["Poison duration", Buff_Poison_Duration.new()], 
	37: ["Sooth", Buff_Sooth.new()],
}


func _ready() -> void:
	next_xp_level = xp_levels.keys()[0]
	previous_xp_level = 0


## Add XP (default to one, could be more for mini-bosses or bosses)
## Also checks if the player reached a new level of XP
func increase(amount: int = 1) -> void:
	if amount >= 1:
		current_xp += amount
	else:
		push_warning("Tried to modify the XP with a negative or zero value, amount was: %s" % amount)
		
	if current_xp >= next_xp_level:
		current_list_of_buffs.append(xp_levels[next_xp_level][1].duplicate())
		previous_xp_level = next_xp_level
		for level: int in xp_levels:
			if current_xp < level:
				next_xp_level = level
				break
	
