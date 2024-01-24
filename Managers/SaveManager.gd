extends Node
## Handles saving and loading of data.
##
## User path: <user>\AppData\Roaming\Fauna-RPG\save.json


const SAVE_GAME_PATH: String = "user://save.json"

# This is intended as the save data for a single run of the game
var save_data: SaveData = null


func _ready() -> void:
	load_game()


func has_save_data() -> bool:
	return save_data != null


# Get all the data you want to save and modify save_data here.
# NOTE: It's recommended to only save data in singletons that are always loaded,
# to prevent errors where the node cannot save since it does not exist in the scene tree.
func save_data_from_nodes():
	PlayerManager.save_player_data()
	CardManager.save_card_data()


# Creates a JSON file with all the save data from save_data
func save_game() -> void:
	if save_data == null:
		save_data = SaveData.new()
	
	save_data_from_nodes()
	
	# Convert save data to dictionary then write to JSON
	var save_data_dictionary: Dictionary = Helpers.inst_to_dict_recursive(save_data)
	assert(save_data_dictionary != null, "Could not convert save data to dictionary!")
	
	var file: FileAccess = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not create save data: %s", FileAccess.get_open_error())
		return
	
	var json_string = JSON.stringify(save_data_dictionary, "\t")
	file.store_string(json_string)
	file.close()


# Loads the JSON file from the player's computer and converts it back to save_data
# NOTE: We don't set up the loaded data on each Node here. Each Node is responsible for setting up
# its saved data whenever it is spawned. Do this by getting a reference to SaveManager.save_data
func load_game() -> void:
	assert(save_data == null, "Tried to load a game when one was already loaded!")
	
	var file: FileAccess = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	if file == null:
		push_error("Could not load save data: %s", FileAccess.get_open_error())
		return
	
	var file_content: String = file.get_as_text()
	if file_content.is_empty():
		push_warning("Save file was empty!")
		return
	
	file.close()
	
	var loaded_dictionary: Dictionary = JSON.parse_string(file_content)
	save_data = Helpers.dict_to_inst_recursive(loaded_dictionary) as SaveData
	
	assert(save_data != null, "Could not convert save data to a Resource!")
