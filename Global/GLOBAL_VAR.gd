extends Node## singleton used to store global values

enum POSSIBLE_MODIFIER_NAMES {
	damage,
	poison,
	draw,
	card_reward_number
}

var MODIFIER_KEYS: Dictionary = {
	"PERMANENT_ADD": "permanent_add",
	"TEMPORARY_ADD": "temporary_add",
	"PERMANENT_MULTIPLY": "permanent_multiply",
	"TEMPORARY_MULTIPLY": "temporary_multiply",
}

# Keys can be accessed with the syntax: GlobalVar.MODIFIER_KEYS.ADD_PERMANENT
# this is useful if we need to change the reference value in multiple places
