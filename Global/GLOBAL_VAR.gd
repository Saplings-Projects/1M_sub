extends Node## singleton used to store global values

var EVENTS_CLASSIFICATION: Array[Resource] = [EventMob, EventRandom, EventShop, EventHeal]

var POSSIBLE_MOVEMENTS: Dictionary = {
	"UP": Vector2(0,1),
	"LEFT": Vector2(-1,1),
	"RIGHT": Vector2(1,1)
}
