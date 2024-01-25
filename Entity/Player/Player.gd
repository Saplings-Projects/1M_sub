extends Entity
class_name Player
## Base player Entity class.

# @Override
func _ready() -> void:
	super()
	PlayerManager.set_player(self)
	
	_handle_load_defaults()



func _exit_tree() -> void:
	# Save player data when they are destroyed (combat end)
	PlayerManager.set_player(null)
	
	_save_persistent_data()


func _handle_load_defaults():
	# If this is our first run, then set all the defaults and save
	if SaveManager.is_first_time_initialization():
		var health_comp: HealthComponent = get_health_component()
		health_comp.set_health_to_max()
		_save_persistent_data()
	else:
		_load_persistent_data()


# Set values from our saved persistent data
func _load_persistent_data():
	var health_comp: HealthComponent = get_health_component()
	
	var new_health: float = SaveManager.save_data.saved_hp
	health_comp.set_health(new_health)


# Update persistent data with our current values
func _save_persistent_data():
	var health_comp: HealthComponent = get_health_component()
	
	SaveManager.save_data.saved_hp = health_comp.current_health
