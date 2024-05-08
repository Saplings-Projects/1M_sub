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


## Modify the health of the entity [br]
## Use the is_healing boolean if you want to heal. [br]
## If the amount is negative, nothing will change. [br]
## Caster can be null [br]
func modify_health(amount: float, caster: Entity, is_healing: bool = false) -> void:
	# Allow caster to be null, but not the target.
	# If caster is null, we assume that the modification came from an unknown source,
	# so status won't calculate.
	var new_health: float

	if amount == 0.0:
		return
	
	assert(owner != null, "No owner was set. Please call init on the Entity.")
	
	var target: Entity = entity_owner # TODO change this name entity_owner to make it clearer
	
	# if the entity calls the function on itself then ignore the caster
	if caster == target: 
		caster = null

	# apply modification to our health
	if is_healing:
		new_health = clampf(current_health + amount, 0, max_health)
	else:
		new_health = clampf(current_health - amount, 0, max_health)
		
	_set_health(new_health)


## Set the health of the entity [br]
func _set_health(new_health: float) -> void:
	if (new_health == current_health):
		return
	current_health = new_health
	on_health_changed.emit(current_health)
