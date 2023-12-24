extends BuffBase
class_name Buff_Strength
## Strength buff increases an Entity's damage stat

# @Override
func get_modified_stats(stats: EntityStats) -> EntityStats:
	stats.damage_dealt_increase += status_power
	# TODO change this to update to the new system
	return stats
