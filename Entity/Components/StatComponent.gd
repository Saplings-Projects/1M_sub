extends EntityComponent
class_name StatComponent
## Holds a reference to stats.
##
## TODO: this doesn't do a whole lot right now. This may be helpful in the future if we want to
## have different stats based on the Entity type.


var _stats: EntityStats = EntityStats.new()


# we want to get a duplicate of stats so we aren't modifying the base.
func get_stat_copy() -> EntityStats:
	return _stats.duplicate()
