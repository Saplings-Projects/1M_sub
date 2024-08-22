extends Node

signal start_load

var save_file: ConfigFile

func _ready() -> void:
	save_file = ConfigFile.new()

func execute_save() -> void:
	XpManager.save_data()
	PlayerManager.save_player()
	MapManager.save_map_data()
	InventoryManager.save_inventory()
	CardManager.save_data()
	SceneManager.save_scene_data()

func execute_load() -> void:
	start_load.emit()

func clear_data() -> void:
	DirAccess.remove_absolute("user://save/current_scene.tscn")
	DirAccess.remove_absolute("user://save/save_data.ini")

func load_save_file() -> ConfigFile:
	var error: Error = save_file.load("user://save/save_data.ini")
	
	if !DirAccess.dir_exists_absolute("user://save/"):
		DirAccess.make_dir_absolute("user://save/")
	
	if error:
		push_error("Error loading save_data ", error)
		return null
	
	return save_file
