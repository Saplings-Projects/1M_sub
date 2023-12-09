extends Resource
class_name StatusBase
## Base status resource
##
## If you want to make a new status, create a child of this.
## If the status applies some sort of instant effect (eg poison), you can use an
## event function like on_turn_end.
## If the status applies persistent changes to the Entity's stats (eg strength), make changes to
## the stats in get_modified_stats.
## Put status in either buff or debuff folder depending on its effect


@export var infinite_duration: bool = false
@export var status_turn_duration: int = 3
@export var status_power: float = 1.0


var status_owner: Entity = null
var status_applier: Entity = null


func init_status(in_owner: Entity, in_applier: Entity) -> void:
	status_owner = in_owner
	status_applier = in_applier


func get_modified_stats(stats: EntityStats) -> EntityStats:
	return stats


func on_turn_start() -> void:
	pass


# other event examples:
# on_take_damage (eg: thorns effect)
# on_application (eg: shield)
# on_card_drawn
