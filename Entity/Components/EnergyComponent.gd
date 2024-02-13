extends Resource
class_name EnergyComponent

@export var max_energy: int = 4
@export var starting_energy: int = 3
var energy = starting_energy


func _ready():
	pass


func use_energy(energy_cost) -> bool:
	if energy >= energy_cost:
		energy -= energy_cost
		return true
	else:
		return false


func on_turn_end():
	if energy > max_energy:
		energy = max_energy

	else:
		energy += 1
