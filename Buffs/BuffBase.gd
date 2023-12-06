extends Resource
class_name BuffBase
## Base buff resource
##
## If you want to make a new buff, create a child of this.
## If the buff applies some sort of instant effect (eg poison), you can use an
## event function like on_turn_end.
## If the buff applies persistent changes to the Entity's stats (eg strength), make changes to
## the stats in get_modified_stats.


@export var infinite_duration: bool = false
@export var buff_turn_duration: int = 3
@export var buff_power: float = 1.0


var buff_owner: Entity = null
var buff_applier: Entity = null


func init_buff(in_owner: Entity, in_applier: Entity) -> void:
	buff_owner = in_owner
	buff_applier = in_applier


func get_modified_stats(stats: EntityStats) -> EntityStats:
	return stats


func on_turn_start() -> void:
	pass


# other event examples:
# on_take_damage (eg: thorns effect)
# on_application (eg: shield)
# on_card_drawn
