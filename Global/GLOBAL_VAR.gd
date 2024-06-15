extends Node
## singleton used to store global values

## The keys to access in each possible modifier
## See [StatModifiers] for more information
var MODIFIER_KEYS: Dictionary = {
	"PERMANENT_ADD": "permanent_add",
	"TEMPORARY_ADD": "temporary_add",
	"PERMANENT_MULTIPLY": "permanent_multiply",
	"TEMPORARY_MULTIPLY": "temporary_multiply",
}

# Keys can be accessed with the syntax: GlobalVar.MODIFIER_KEYS.ADD_PERMANENT
# this is useful if we need to change the reference value in multiple places

## A list of all the possible events
var EVENTS_CLASSIFICATION: Array[Resource] = [EventMob, EventRandom, EventShop, EventHeal, EventDialogue]

## A list of the probabilities of all possible events
var EVENTS_PROBABILITIES: Array[float] = [45.0, 16.0, 5.0, 12.0, 22.0]

## A list of all the possible movements on the map
var POSSIBLE_MOVEMENTS: Dictionary = {
	"UP": Vector2i(0,1),
	"LEFT": Vector2i(-1,1),
	"RIGHT": Vector2i(1,1)
}
