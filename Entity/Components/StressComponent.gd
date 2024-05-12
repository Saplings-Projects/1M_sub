class_name StressComponent extends EntityComponent
## Holds entities stress
##
## Allows entities to deal stress damage or sooth. Manages stress generation

## Emit when stress is changed
signal on_stress_changed(new_stress: int)

## The maximum stress the entity can have. This is a hard limit
@export var max_stress: int = 100

## The amount of stress the entity generates at the start of each turn
@export var stress_generation: int = 5

## Know if an entity has been calmed already or not [br]
## This is used to not distribute XP twice for the same entity, even if it is calmed multiple times [br]
var has_been_calmed: bool = false

## The current stress the entity has [br]
## Between 0 and [member StressComponent.max_stress]
var current_stress: int

## @Override [br]
## Initialize the stress component, putting stress to max stress [br]
## This does not happen at game start for the player, as only enemies have a stress component [br]
## For enemies, this is called when the scene is instantiated (or more accurately, when each enemy is instanciated) [br]
func _ready() -> void:
	_set_stress(floor(max_stress / 2.))


## Used to emit the specific signal for this class [br]
func _emit_class_signal() -> void:
	on_stress_changed.emit(current_stress)
	
## Modify the stress of the entity [br]
## Use the is_healing boolean if you want to heal. [br]
## If the amount is negative, nothing will change. [br]
## Caster can be null [br]
func modify_stress(amount: int, caster: Entity, is_sooth: bool = false) -> void:
	# Allow caster to be null, but not the target.
	# If caster is null, we assume that the modification came from an unknown source,
	# so status won't calculate.
	var new_stress: int

	if amount <= 0.0:
		return
	
	assert(owner != null, "No owner was set. Please call init on the Entity.")
	
	var target: Entity = entity_owner # TODO change this name entity_owner to make it clearer
	
	# if the entity calls the function on itself then ignore the caster
	if caster == target: 
		caster = null

	# apply modification to our stress
	if is_sooth:
		new_stress = clamp(current_stress + amount, 0, max_stress)
	else:
		new_stress = clamp(current_stress - amount, 0, max_stress)
		
	_set_stress(new_stress)


## Set the stress of the entity [br]
func _set_stress(new_stress: int) -> void:
	if (new_stress == current_stress):
		return
	current_stress = new_stress
	_emit_class_signal()
	

## To be called on combat turn start [br]
## Add the stress generation to the current stress
func on_turn_start() -> void:
	# If the entity is not calmed, continue generating stress
	if current_stress >= 1:
		current_stress += stress_generation
		current_stress = clamp(current_stress, 0, max_stress)
		_emit_class_signal()
	

## Puts back the stress to the default value of max / 2
func _reset_stress() -> void:
	current_stress = floor(max_stress / 2.)
	_emit_class_signal()


## Rewards XP for calming the entity, stops stress generation	
func on_calmed() -> void:
	pass
	#TODO reward XP


## Makes the entity execute a powerful attack and resets the stress to its default value
func on_overstress() -> void:
	# TODO make the powerful attack
	_reset_stress()