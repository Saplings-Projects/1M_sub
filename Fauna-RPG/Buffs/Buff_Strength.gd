extends BuffBase
class_name Buff_Strength
## Strength buff increases an Entity's damage stat


func get_modified_stats(stats : EntityStats) -> EntityStats:
	stats.damage_dealt_increase += buff_power
	return stats
