extends EntityComponent
class_name HealthComponent
## Everything related to health for all entities
##
## Holds player / enemies health values and allows for dealing damage.

## Emit when health is changed
signal on_health_changed(new_health: int)

## The maximum health the entity can have; this is a hard limit
@export var max_health: float = 100
## The health the entity currently has [br]
## Between 0 and max_health
var current_health: float = 100 # ? change this to max health, or just unset since it's init by the ready

## Initialize the health component, putting health to max health
## This only happens at game start for the player, the value is then tracked inside the [PlayerManager] singleton [br]
## For enemies, this is called when the scene is instantiated (or more accurately, when each enemy is instanciated) [br]
func _ready() -> void:
	_set_health(max_health)


## Deal damage to the entity [br]
## Use a negative damage value if you want to heal. [br]
## Caster can be null [br]
func deal_damage(damage: float, caster: Entity) -> void:
	# Allow caster to be null, but not the target.
	# If caster is null, we assume that the damage came from an unknown source,
	# so status won't calculate.
	
	if damage == 0.0:
		return
	
	assert(owner != null, "No owner was set. Please call init on the Entity.")
	
	var target: Entity = entity_owner # TODO change this name entity_owner to make it clearer
	
	# if this was a self attack, ignore the caster
	if caster == target: 
		caster = null

	# apply damage to our health
	var new_health: float = clampf(current_health - damage, 0, max_health)
	_set_health(new_health)


## Set the health of the entity [br]
func _set_health(new_health: float) -> void:
	if (new_health == current_health):
		return
	current_health = new_health
	on_health_changed.emit(current_health)
