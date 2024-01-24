extends Entity
class_name Player
## Base player Entity class.

# @Override
func _ready() -> void:
	super()
	PlayerManager.set_player(self)
	
	setup_player_health()

func _exit_tree() -> void:
	PlayerManager.set_player(null)


func setup_player_health():
	var health_comp: HealthComponent = get_health_component()
	
	# If there is no saved data, start with the max health
	if not SaveManager.has_save_data():
		health_comp.set_health_to_max()
	else:
		var new_health: float = SaveManager.save_data.saved_hp
		
		if new_health <= 0.0:
			assert("Created a player with 0 health!")
		
		health_comp.set_health(new_health)
