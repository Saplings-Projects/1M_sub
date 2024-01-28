extends Node
## Handles saving and loading of data.
##
## User path: <user>\AppData\Roaming\Fauna-RPG\save.json


signal on_pre_save

const SAVE_GAME_PATH: String = "user://save.json"
const BACKUP_SAVE_GAME_PATH: String = "user://save_bak.json"

var save_data: SaveData = SaveData.new()
var save_to_file: bool = false


func _ready() -> void:
	load_game()


func _exit_tree() -> void:
	save_game()


# Creates a JSON file with all the save data from save_data
func save_game() -> void:
	if not save_to_file:
		return
	
	on_pre_save.emit()
	
	# Convert save data to dictionary then write to JSON
	var save_data_dictionary: Dictionary = Helpers.inst_to_dict_recursive(save_data)
	assert(save_data_dictionary != null, "Could not convert save data to dictionary!")
	
	var file: FileAccess = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not create save data: ", FileAccess.get_open_error())
		return
	
	var json_string = JSON.stringify(save_data_dictionary, "\t")
	file.store_string(json_string)
	file.close()
	
	# Create a backup by copying the save data.
	var backup_error: Error = DirAccess.copy_absolute(SAVE_GAME_PATH, BACKUP_SAVE_GAME_PATH)
	if backup_error != OK:
		push_error("Backup could not be created: ", backup_error)


# Loads the JSON file from the player's computer and converts it back to save_data
# NOTE: We don't set up the loaded data on each Node here. Each Node is responsible for setting up
# its saved data whenever it is spawned. Do this by getting a reference to SaveManager.save_data
func load_game() -> void:
	# First try to load the main file. If it fails, then try to load the backup
	if not load_save_at_path(SAVE_GAME_PATH):
		load_save_at_path(BACKUP_SAVE_GAME_PATH)


func load_save_at_path(path: String) -> bool:
	var file_exists = FileAccess.file_exists(path)
	if not file_exists:
		# We assume save data is valid if the file doesn't exist, because it might not have been created yet
		return true

	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Could not load save data: ", error_string(FileAccess.get_open_error()))
		return false
	
	var file_content: String = file.get_as_text()
	if file_content.is_empty():
		push_error("Save file was empty!")
		return false
	
	file.close()
	
	var json = JSON.new()
	var parse_error: Error = json.parse(file_content)
	if parse_error != OK:
		push_error("Error opening save: ", error_string(parse_error))
		return false
	
	save_data = Helpers.dict_to_inst_recursive(json.data) as SaveData
	
	assert(save_data != null, "Could not convert save data to a Resource!")
	
	return true


func clear_save() -> void:
	var error: Error = DirAccess.remove_absolute(SAVE_GAME_PATH)
	if error != OK:
		push_error("Could not remove save file: ", error_string(error))
	
	error = DirAccess.remove_absolute(BACKUP_SAVE_GAME_PATH)
	if error != OK:
		push_error("Could not remove backup save file: ", error_string(error))
	
