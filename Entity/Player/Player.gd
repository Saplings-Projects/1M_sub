extends Entity
class_name Player
## Base player Entity class.

# @Override
func _ready() -> void:
	super()
	PlayerManager.set_player(self)
	get_energy_component().init_entity_component(self)


func _exit_tree() -> void:
	PlayerManager.set_player(null)

#this PR is going to be so easy
func get_energy_component() -> EnergyComponent:
	return Helpers.get_first_child_node_of_type(self, EnergyComponent) as EnergyComponent