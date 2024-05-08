class_name StressComponent extends HealthComponent
## Holds entities stress
##
## Allows entities to deal stress damage or sooth. Manages stress generation

## Emit when stress is changed
signal on_stress_changed(new_stress: int)

## The maximum stress the entity can have. This is a hard limit
@export var max_stress: int = 100

## The amount of stress the entity generates at the start of each turn
@export var stress_generation: int = 5

## Used to tell if an entity will add stress_generation to its current_stress on the start of the turn [br]
## This is generally true, but is put to false whenever the entity is in a calm (state ie, stress reduced to 0)
var stress_buildup: bool = true

## Know if an entity has been calmed already or not [br]
## This is used to not distribute XP twice for the same entity, even if it is calmed multiple times [br]
var has_been_calmed: bool = false

## The current stress the entity has [br]
## Between 0 and [member StressComponent.max_stress]
var current_stress: int = floor(max_stress / 2.)

## @Override [br]
## Initialize the stress component, putting stress to max stress [br]
## This does not happen at game start for the player, as only enemies have a stress component [br]
## For enemies, this is called when the scene is instantiated (or more accurately, when each enemy is instanciated) [br]
func _ready() -> void:
	_set_health(max_stress)


## @Override [br]
## Used to emit the specific signal for this class [br]
func _emit_class_signal() -> void:
	on_stress_changed.emit(current_stress)
	

## To be called on combat turn start [br]
## Add the stress generation to the current stress
func on_turn_start() -> void:
	pass
	

## Puts back the stress to the default value of max / 2
func _reset_stress() -> void:
	pass


## Rewards XP for calming the entity, stops stress generation	
func on_calmed() -> void:
	pass


## Makes the entity execute a powerful attack and resets the stress to its default value
func on_overstress() -> void:
	pass