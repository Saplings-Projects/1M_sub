extends EntityComponent
class_name EnergyComponent

@export var MAX_ENERGY: int = 4
@export var starting_energy: int = 3
@export var energy_generation: int = 3
@export var ignore_cost: bool = false
var energy: int = starting_energy

	

signal on_energy_changed

func is_playable(card: CardWorld) -> bool:
	if ignore_cost:
		return true

	if card != null:
		return energy >= card.card_data.energy_info.energy_cost

	return true


func use_energy(card: CardBase) -> void:
	energy -= card.energy_info.energy_cost

	if energy < 0 and !ignore_cost:
		print_stack()
		push_error("energy cannot be negative")

	on_energy_changed.emit()


func on_turn_start() -> void:

	energy += energy_generation

	if energy >= MAX_ENERGY:
		energy = MAX_ENERGY

	on_energy_changed.emit()

func add_energy(value: int) -> void:
	energy += value
