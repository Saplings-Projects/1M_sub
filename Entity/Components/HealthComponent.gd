extends EntityComponent
class_name HealthComponent
## Holds player health values and allows for dealing damage.


signal on_health_changed(new_health: int)

@export var max_health: float = 100
var current_health: float = 100


func _ready() -> void:
	_set_health(max_health)


# Allow caster to be null, but not the target.
# If caster is null, we assume that the damage came from an unknown source,
# so status won't calculate.
# Use a negative damage value if you want to heal.
func deal_damage(damage_data: DealDamageData) -> void:
	var damage: float = damage_data.damage

	if damage == 0.0:
		return
	
	assert(owner != null, "No owner was set. Please call init on the Entity.")
	
	var target: Entity = entity_owner
	var caster: Entity = damage_data.caster
	
	# if this was a self attack, ignore the caster
	if caster == target: 
		caster = null
	
	# get stats from our stat components
	var modified_caster_stats: EntityStats = null
	if caster != null:
		modified_caster_stats = caster.get_stat_component().get_stat_copy()
	var modified_target_stats: EntityStats = target.get_stat_component().get_stat_copy()
	
	# apply modified damage from status
	if caster != null and !damage_data.ignore_caster_status:
		for status: StatusBase in caster.get_status_component().current_status:
			status.get_modified_stats(modified_caster_stats)
	if !damage_data.ignore_target_status:
		for status: StatusBase in target.get_status_component().current_status:
			status.get_modified_stats(modified_target_stats)
	
	var damage_taken_increase: float = 0.0
	var damage_dealt_increase: float = 0.0

	# we don't want to take into account these status when healing
	# TODO if desired, we can add stats for healing status increases (we heal when damage < 0)
	if damage > 0.0:
		damage_taken_increase = modified_target_stats.damage_taken_increase
		if caster != null:
			damage_dealt_increase = modified_caster_stats.damage_dealt_increase
	
	# find modified damage based on status
	var total_damage: float = damage + damage_taken_increase + damage_dealt_increase

	# apply damage to our health
	var new_health: float = clampf(current_health - total_damage, 0, max_health)
	_set_health(new_health)


func _set_health(new_health: float) -> void:
	if (new_health == current_health):
		return
	current_health = new_health
	on_health_changed.emit(current_health)
