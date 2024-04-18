extends EntityComponent
class_name EnergyComponent
## Store the energy of the player
##
## This is globally loaded as this is used as a singleton

## The max energy that a player can have after energy generation at the start of the turn [br]
## Note that this is a soft limit, meaning the player can generate energy during its turn and go over this limit
@export var MAX_ENERGY: int = 4
## The energy a player starts the fight with
@export var starting_energy: int = 3
## The energy generation at the start of the turn [br]
## Note that energy carries over from turn to turn, ie a player with 1 energy will end up with 4 energy on the next turn [br]
## A player with 2, 3 or 4 energy will also end up with 4 energy, because of the soft energy limit (2 -> +3 -> 5 -> too high -> 4)
@export var energy_generation: int = 3
## Should the cost of the card be ignored or not ? [br]
## Mainly used in tests
## @experimental
@export var ignore_cost: bool = false
## The current energy of the player, will change during the turns
var energy: int = starting_energy

## A signal emitted when player energy changes
signal on_energy_changed

## Checks whether or not a card is playable, based only on the cost of the card [br]
## Note that the card might not be playable for other reasons, such as the target of the card not being valid (using a card for allies on enemies for example) [br]
## ? where is the agregate of all the is_playable checks ? [br]
func is_playable(card: CardWorld) -> bool:
	if ignore_cost:
		return true

	if card != null:
		return energy >= card.card_data.energy_info.energy_cost

	return true

## Change the energy of the player based on the cost of the card [br]
func use_energy(card: CardBase) -> void:
	energy -= card.energy_info.energy_cost

	if energy < 0 and !ignore_cost:
		print_stack()
		push_error("energy cannot be negative")

	on_energy_changed.emit()


## Add energy to the player at turn start, capped at MAX_ENERGY [br]
func on_turn_start() -> void:

	energy += energy_generation

	if energy >= MAX_ENERGY:
		energy = MAX_ENERGY

	on_energy_changed.emit()

## Add energy to the player [br]
## ? Should this be moved to be a setter on energy [br]
func add_energy(value: int) -> void:
	energy += value
