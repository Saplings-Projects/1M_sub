extends EntityComponent
class_name HealthComponent
## Everything related to health for all entities
##
## Holds player / enemies health values and allows for dealing damage.

## Emit when health is changed
signal on_health_changed(new_health: int)

signal on_block_changed(new_block: int)

## The maximum health the entity can have; this is a hard limit
@export var max_health: float = 100
## The health the entity currently has [br]
## Between 0 and max_health
var current_health: float = 100 # ? change this to max health, or just unset since it's init by the ready


var current_block: float = 100

## Initialize the health component, putting health to max health
## This only happens at game start for the player, the value is then tracked inside the [PlayerManager] singleton [br]
## For enemies, this is called when the scene is instantiated (or more accurately, when each enemy is instanciated) [br]
func _ready() -> void:
	_set_health(max_health)

func take_damage_block_and_health(amount : float, _caster: Entity) -> void:
	if amount <= 0.0:
		return
	
	var leftover_damage: float
	leftover_damage = amount
	
	leftover_damage = block_damage(leftover_damage)
	health_damage(leftover_damage)

func health_damage(damage : int) -> void:
	var new_health : int
	new_health = current_health
	
	new_health = clampf(current_health - damage, 0, max_health)
	_set_health(new_health)

func heal(amount : int) -> void:
	var new_health : int
	new_health = current_health
	
	new_health = clampf(current_health + amount, 0, max_health)
	_set_health(new_health)

## Set the health of the entity [br]
func _set_health(new_health: float) -> void:
	if (new_health == current_health):
		return
	current_health = new_health
	on_health_changed.emit(current_health)

func block_damage(damage: int) -> int:
	var new_block : int
	new_block = current_block
	
	var leftover_damage : int
	leftover_damage = damage - current_block
	new_block = min(new_block - damage, 0)
	_set_block(new_block)
	
	return leftover_damage

func get_block(amount : int) -> void:
	var new_block : int
	new_block = current_block
	
	new_block = new_block + amount
	_set_block(new_block)
	

func _set_block(new_block: float) -> void:
	if (new_block == current_block):
		return
	
	current_block = new_block
	on_block_changed.emit(current_block)
