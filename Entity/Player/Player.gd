extends Entity
class_name Player
## Base player Entity class.

# @Override
func _ready() -> void:
	super()
	PlayerManager.set_player(self)
	
	_load_persistent_data()


func _exit_tree() -> void:
	# Save player data when they are destroyed (combat end)
	PlayerManager.set_player(null)
	
	_save_persistent_data()


# Set values from our saved persistent data
func _load_persistent_data():
	if PlayerManager.try_load_persistent_data() == null:
		return
	
	var health_comp: HealthComponent = get_health_component()
	
	var new_health: float = PlayerManager.player_persistent_data.saved_health
	health_comp.set_health(new_health)


# Update persistent data with our current values
func _save_persistent_data():
	if PlayerManager.player_persistent_data == null:
		PlayerManager.create_persistent_data()
	
	var health_comp: HealthComponent = get_health_component()
	
	PlayerManager.player_persistent_data.saved_health = health_comp.current_health
