extends Node## singleton used to store global values

var EVENTS_CLASSIFICATION: Array[Resource] = [EventMob, EventRandom, EventShop, EventHeal]

var POSSIBLE_MOVEMENTS: Dictionary = {
	"UP": Vector2i(0,-1),
	"LEFT": Vector2i(-1,-1),
	"RIGHT": Vector2i(1,-1)
}
# it's a bit counter intuitive, but level 0 is the start of the array which means the top of the map
# so when we go "UP" in the map, we go towards the index 0 of the array
