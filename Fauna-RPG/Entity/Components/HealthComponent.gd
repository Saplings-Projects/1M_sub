extends EntityComponent
class_name HealthComponent
## Holds player health values and allows for dealing damage.


signal on_health_changed(new_health: int)

@export var max_health: float = 100
var current_health: float = 100


func _ready() -> void:
	_set_health(max_health)


# Allow attacker to be null, but not the victim.
# If attacker is null, we assume that the damage came from an unknown source,
# so buffs won't calculate.
# Use a negative damage value if you want to heal.
func deal_damage(damage_data: DealDamageData) -> void:
	var damage: float = damage_data.damage

	if damage == 0.0:
		return
	
	assert(owner != null, "No owner was set. Please call init on the Entity.")
	
	var victim: Entity = entity_owner
	var attacker: Entity = damage_data.attacker
	
	# if this was a self attack, ignore the attacker
	if attacker == victim: 
		attacker = null
	
	# get stats from our stat components. We need to duplicate otherwise
	# we're changing the base stats
	var modified_attacker_stats: EntityStats = null
	if attacker != null:
		modified_attacker_stats = attacker.get_stat_component().stats.duplicate()
	var modified_victim_stats: EntityStats = victim.get_stat_component().stats.duplicate()
	
	# apply buffs
	if attacker != null and !damage_data.ignore_attacker_buffs:
		for buff: BuffBase in attacker.get_buff_component().current_buffs:
			buff.get_modified_stats(modified_attacker_stats)
	if !damage_data.ignore_victim_buffs:
		for buff: BuffBase in victim.get_buff_component().current_buffs:
			buff.get_modified_stats(modified_victim_stats)
	
	var damage_taken_increase: float = 0.0
	var damage_dealt_increase: float = 0.0

	# we don't want to take into account these buffs when healing
	# TODO if desired, we can add stats for healing buff increases (we heal when damage < 0)
	if damage > 0.0:
		damage_taken_increase = modified_victim_stats.damage_taken_increase
		if attacker != null:
			damage_dealt_increase = modified_attacker_stats.damage_dealt_increase
	
	# find modified damage based on buffs
	var total_damage: float = damage + damage_taken_increase + damage_dealt_increase

	# apply damage to our health
	var new_health: float = clampf(current_health - total_damage, 0, max_health)
	_set_health(new_health)


func _set_health(new_health: float) -> void:
	if (new_health == current_health):
		return
	current_health = new_health
	on_health_changed.emit(current_health)
