extends Entity
class_name Player
## Base player Entity class.

## A boolean used to know if the data on the player should be saved when the player is destroyed.
## This is useful when exiting combat, as the player is destroyed and re-created when entering combat.
var _should_save_persistent_data: bool = true

## @Override [br]
## See [Entity] for more information [br]
## Also loads the player's persistent data.
func _ready() -> void:
	super()
	_load_persistent_data()
	PlayerManager.set_player(self)
	


## Call when the player is destroyed. [br]
## Saves data if _should_save_persistent_data is true.
func _exit_tree() -> void:
	# Save player data when they are destroyed (combat end)
	PlayerManager.set_player(null)

	if _should_save_persistent_data:
		_save_persistent_data()


## Set values from our saved persistent data [br]
## Used when player enters combat.
func _load_persistent_data() -> void:
	# If we don't have any persistent data, we will use the defaults
	if PlayerManager.player_persistent_data == null:
		return
	
	# Load health data
	var health_comp: HealthComponent = get_health_component()
	var new_health: float = PlayerManager.player_persistent_data.saved_health
	health_comp._set_health(new_health)
	
	# Load stat data
	var loaded_stats: EntityStats = PlayerManager.player_persistent_data.saved_stats;
	var stat_comp: StatComponent = get_stat_component()
	stat_comp.stats = loaded_stats


## Update persistent data with our current values [br]
## The values are stored in the player manager. [br]
## Note that this is not an save that will persist between game sessions. [br]
func _save_persistent_data() -> void:
	if PlayerManager.player_persistent_data == null:
		PlayerManager.create_persistent_data()
	
	# Save health data
	var health_comp: HealthComponent = get_health_component()
	PlayerManager.player_persistent_data.saved_health = health_comp.current_health
	
	# Save stat data
	var stat_comp: StatComponent = get_stat_component()
	# it should already be properly done, but just in case
	stat_comp.stats.reset_modifier_dict_temp_to_default()
	PlayerManager.player_persistent_data.saved_stats = stat_comp.stats


## Get the energy of the player [br]
## This is not in [Entity] since only the player has energy.
func get_energy_component() -> EnergyComponent:
	return Helpers.get_first_child_node_of_type(self, EnergyComponent) as EnergyComponent
