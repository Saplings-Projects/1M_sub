extends Resource
class_name PlayerPersistentData
## Store player data that we want to persist between scenes here.


var saved_health: int
var saved_stats: EntityStats


func _init() -> void:
	saved_health = -1
	saved_stats = null
