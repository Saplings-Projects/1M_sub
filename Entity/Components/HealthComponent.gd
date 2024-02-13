extends EntityComponent
class_name HealthComponent
## Holds player health values and allows for dealing damage.


signal on_health_changed(new_health: int)

@export var max_health: float = 100
var current_health: float = 100


func _ready() -> void:
	set_health(max_health)


# Allow caster to be null, but not the target.
# If caster is null, we assume that the damage came from an unknown source,
# so status won't calculate.
# Use a negative damage value if you want to heal.
func deal_damage(damage: float, caster: Entity) -> void:
	
	if damage == 0.0:
		return
	
	assert(owner != null, "No owner was set. Please call init on the Entity.")
	
	var target: Entity = entity_owner
	
	# if this was a self attack, ignore the caster
	if caster == target: 
		caster = null

	# apply damage to our health
	var new_health: float = clampf(current_health - damage, 0, max_health)
	set_health(new_health)


func set_health(new_health: float) -> void:
	if (new_health == current_health):
		return
	current_health = new_health
	on_health_changed.emit(current_health)
