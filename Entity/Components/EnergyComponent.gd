extends EntityComponent
class_name EnergyComponent

@export var max_energy: int = 4
@export var starting_energy: int = 0
@export var energy_generation: int = 3
@export var ignore_cost: bool = false
var energy = starting_energy

signal on_energy_changed(new_energy: int)

func is_playable(card: CardWorld) -> bool:
	if ignore_cost:
		return true

	if card != null:
		return energy >= card.card_data.energy_cost

	return true


func use_energy(card: CardBase) -> void:
	energy -= card.energy_cost

	if energy < 0:
		energy = 0

	on_energy_changed.emit(energy)


func on_turn_end() -> void:
	if energy >= max_energy:
		energy = max_energy
		
	else:
		energy += energy_generation
	
	on_energy_changed.emit(energy)
