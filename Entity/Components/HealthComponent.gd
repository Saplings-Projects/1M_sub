extends EntityComponent
class_name HealthComponent
## Everything related to health for all entities
##
## Holds player / enemies health values and allows for dealing damage.

## Emit when health is changed
signal on_health_changed(new_health: int)

signal on_block_changed(new_block: int)

## The maximum health the entity can have; this is a hard limit
@export var max_health: int = 100
## The health the entity currently has [br]
## Between 0 and max_health
var current_health: int = 100 # ? change this to max health, or just unset since it's init by the ready


var current_block: int = 0

## Initialize the health component, putting health to max health
## This only happens at game start for the player, the value is then tracked inside the [PlayerManager] singleton [br]
## For enemies, this is called when the scene is instantiated (or more accurately, when each enemy is instanciated) [br]
func _ready() -> void:
	_set_health(max_health)
	PhaseManager.on_phase_changed.connect(reset_block)

## The intended way for entities to take damage.[br]
## Removes block first and then deals excess damage to the health[br]
func take_damage_block_and_health(amount : int, caster: Entity) -> void:
	if amount <= 0.0:
		return
		
	assert(owner != null, "No owner was set. Please call init on the Entity.")
	
	var target: Entity = entity_owner # TODO change this name entity_owner to make it clearer
	
	# if the entity calls the function on itself then ignore the caster
	if caster == target: 
		caster = null

	
	var leftover_damage: int = amount
	leftover_damage = block_damage(leftover_damage)
	_health_damage(leftover_damage)

## removes health without considering block [br]
## primarily a helper function, but could be used in future for block ignoring attacks[br]
func _health_damage(damage : int) -> void:
	if damage <= 0.0:
		return
	
	var new_health : int = current_health
	
	new_health = clampf(new_health - damage, 0, max_health)
	_set_health(new_health)

## adds health to the unit[br]
func heal(amount : int,  _caster : Entity) -> void:
	if amount <= 0.0:
		return
	
	var new_health : int = current_health
	
	new_health = clampf(new_health + amount, 0, max_health)
	_set_health(new_health)

## Set the health of the entity [br]
func _set_health(new_health: int) -> void:
	if (new_health == current_health):
		return
	current_health = new_health
	on_health_changed.emit(current_health)

## Removes block from the entity[br]
func block_damage(damage: int) -> int:
	if damage <= 0.0:
		return 0
	
	var new_block : int = current_block
	
	var leftover_damage : int
	leftover_damage = max(damage - current_block, 0)
	
	new_block = max(new_block - damage, 0)
	_set_block(new_block)
	
	return leftover_damage

## Adds block to the entity[br]
func add_block(amount : int, _caster : Entity) -> void:
	var new_block : int
	new_block = current_block
	
	new_block = new_block + amount
	
	_set_block(new_block)
	

## Set the block of the entity [br]
func _set_block(new_block: int) -> void:
	if (new_block == current_block):
		return
	
	current_block = new_block
	on_block_changed.emit(current_block)

func reset_block_on_round_start(new_phase: GlobalEnums.Phase, _old_phase: GlobalEnums.Phase) -> void:
	if(new_phase == GlobalEnums.Phase.PLAYER_ATTACKING):
		reset_block()

## Sets block to 0 [br]
func reset_block() -> void:
	_set_block(0)
