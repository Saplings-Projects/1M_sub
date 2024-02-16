extends Entity
class_name Player
## Base player Entity class.

# @Override
func _ready() -> void:
	super()
	PlayerManager.set_player(self)


func _exit_tree() -> void:
	PlayerManager.set_player(null)


func get_energy_component() -> EnergyComponent:
	return Helpers.get_first_child_node_of_type(self, EnergyComponent) as EnergyComponent
	