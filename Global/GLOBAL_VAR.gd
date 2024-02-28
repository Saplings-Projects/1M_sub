extends Node## singleton used to store global values

enum POSSIBLE_MODIFIER_NAMES {
	DAMAGE,
	POISON,
	DRAW,
	CARD_REWARD_NUMBER
}

var MODIFIER_KEYS: Dictionary = {
	"PERMANENT_ADD": "permanent_add",
	"TEMPORARY_ADD": "temporary_add",
	"PERMANENT_MULTIPLY": "permanent_multiply",
	"TEMPORARY_MULTIPLY": "temporary_multiply",
}

# Keys can be accessed with the syntax: GlobalVar.MODIFIER_KEYS.ADD_PERMANENT
# this is useful if we need to change the reference value in multiple places

enum ENTITY_STAT_DICT_TYPE {
	OFFENSE,
	DEFENSE
}

# used to select the offfense or defense dictionary for the stats of an entity
# ! don't forget to update _ENTITY_STAT_DICT_SELECTOR in EntityStats.gd if you modify this

var EVENTS_CLASSIFICATION: Array[Resource] = [EventMob, EventRandom, EventShop, EventHeal]

var POSSIBLE_MOVEMENTS: Dictionary = {
	"UP": Vector2i(0,1),
	"LEFT": Vector2i(-1,1),
	"RIGHT": Vector2i(1,1)
}
