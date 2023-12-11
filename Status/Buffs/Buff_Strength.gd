extends StatusBase
class_name Buff_Strength
## Strength buff increases an Entity's damage stat

# @Override
func get_modified_stats(stats: EntityStats) -> EntityStats:
	stats.damage_dealt_increase += status_power
	return stats
