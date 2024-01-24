extends Node
## Handles saving and loading of data.


const SAVE_GAME_PATH: String = "user://save.json"

var save_data: SaveData = null


func _ready() -> void:
	load_game()


func has_save_data() -> bool:
	return save_data != null


func save_game() -> void:
	if save_data == null:
		save_data = SaveData.new()
	
	PlayerManager.save_player_data(save_data)
	CardManager.save_card_data(save_data)
	
	# Convert save data to dictionary then write to JSON
	var save_data_dictionary: Dictionary = Helpers.inst_to_dict_recursive(save_data)
	if save_data_dictionary == null:
		assert("Could not convert save data to dictionary!")
		return
	
	var file: FileAccess = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not create save data: %s", FileAccess.get_open_error())
		return
	
	var json_string = JSON.stringify(save_data_dictionary, "\t")
	file.store_string(json_string)
	file.close()


func load_game() -> void:
	if save_data != null:
		assert("Tried to load a game when one was already loaded!")
		return
	
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
	
	if save_data == null:
		assert("Could not convert save data to instance!")
	
	# NOTE: We don't set up the loaded data on each Node here. Each Node is responsible for setting up
	# its saved data whenever it is spawned
