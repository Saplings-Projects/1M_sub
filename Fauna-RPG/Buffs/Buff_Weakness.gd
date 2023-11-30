extends BuffBase
class_name Buff_Weakness
## Vulnerability buff decreases the amount of damage that an Entity deals


func get_modified_stats(stats : EntityStats) -> EntityStats:
	stats.damage_dealt_increase -= buff_power
	return stats
