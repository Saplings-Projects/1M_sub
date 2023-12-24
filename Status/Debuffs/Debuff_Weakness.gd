extends DebuffBase
class_name Debuff_Weakness
## Vulnerability buff decreases the amount of damage that an Entity deals

# @Override
func get_modified_stats(stats: EntityStats) -> EntityStats:
	stats.damage_dealt_increase -= status_power
	# TODO change this to update to the new system
	return stats
