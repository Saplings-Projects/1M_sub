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

	# apply damage to our health
	var new_health: float = clampf(current_health - damage, 0, max_health)
	_set_health(new_health)


func _set_health(new_health: float) -> void:
	if (new_health == current_health):
		return
	current_health = new_health
	on_health_changed.emit(current_health)
