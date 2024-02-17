extends Label

var energy_component: EnergyComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	energy_component = PlayerManager.player.get_energy_component()
	energy_component.on_energy_changed.connect(on_energy_changed)
	CardManager.on_card_action_finished.connect(on_card_played)
	update_label()


func on_card_played(_card):
	update_label()

func on_energy_changed():
	update_label()

func update_label():
	text = str(energy_component.energy)