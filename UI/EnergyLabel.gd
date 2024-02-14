extends Label

var energy_component: EnergyComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	energy_component = PlayerManager.player.get_energy_component()

	energy_component.on_energy_changed.connect(on_energy_change)
	CardManager.on_card_action_finished.connect(on_card_played)
	PhaseManager.on_phase_changed.connect(on_turn_end)
	update_label()

func on_turn_end(_new_phase, _old_phase):
	print("phase change")
	update_label()


func on_card_played(_card):
	print("card played")
	update_label()

func on_energy_change():
	print("card played")
	update_label()

func update_label():
	print(energy_component.energy)
	print("asdfjodisj")
	text = str(energy_component.energy)
