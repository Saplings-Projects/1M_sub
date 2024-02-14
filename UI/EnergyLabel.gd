extends Label

var energy_component: EnergyComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	energy_component = PlayerManager.player.get_energy_component()

	energy_component.on_energy_changed.connect(_set_label)
	_set_label(energy_component.energy)

func on_turn_end():
	pass

func _set_label(new_energy):
	text = str(new_energy)
