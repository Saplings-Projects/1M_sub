extends EntityComponent
class_name HealthComponent
## Holds player health values and allows for dealing damage.


signal on_health_changed(new_health: int)

@export var max_health: float = 100
@export var set_to_max_health_on_ready = true
var current_health: float = 100


func _ready() -> void:
	if set_to_max_health_on_ready:
		set_health_to_max()


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
	var new_health: float = clampf(current_health - total_damage, 0, max_health)
	set_health(new_health)


func set_health(new_health: float) -> void:
	if (new_health == current_health):
		return
	current_health = new_health
	on_health_changed.emit(current_health)


func set_health_to_max():
	set_health(max_health)
