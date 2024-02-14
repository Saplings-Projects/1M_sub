extends EntityComponent
class_name EnergyComponent

@export var Max_energy: int = 4
@export var starting_energy: int = 0
@export var energy_generation: int = 3
@export var ignore_cost: bool = false
var energy = starting_energy

signal on_energy_changed

func is_playable(card: CardWorld) -> bool:
	if ignore_cost:
		return true

	if card != null:
		return energy >= card.card_data.energy.energy_cost

	return true


func use_energy(card: CardBase) -> void:
	energy -= card.energy.energy_cost

	if energy < 0:
		push_error("energy cannot be negative")

	on_energy_changed.emit()


func on_turn_end() -> void:

	energy += energy_generation

	if energy >= Max_energy:
		energy = Max_energy

	on_energy_changed.emit()

func add_energy(value: int) -> void:
	energy += value
	print(energy)
