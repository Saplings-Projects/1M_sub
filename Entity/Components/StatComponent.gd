extends EntityComponent
class_name StatComponent
## Holds a reference to stats.
##
## TODO: this doesn't do a whole lot right now. This may be helpful in the future if we want to
## have different stats based on the Entity type.


var _stats: EntityStats = EntityStats.new()


func set_stats(new_stats: EntityStats) -> void:
	_stats = new_stats


func get_stats() -> EntityStats:
	return _stats
