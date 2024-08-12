extends Node

signal start_save
signal start_load

var config_file: ConfigFile

func _ready() -> void:
	config_file = ConfigFile.new()

func execute_save() -> void:
	start_save.emit()

func execute_load() -> void:
	start_load.emit()

func clear_data() -> void:
	DirAccess.remove_absolute("user://current_scene.tscn")
	DirAccess.remove_absolute("user://save_data.ini")
	config_file.clear()
	var error: Error = config_file.save("user://save_data.ini")
	if error:
		print("Error saving player data: ", error)

func load_config_file() -> ConfigFile:
	var error: Error = config_file.load("user://save_data.ini")
	if error:
		print("Error loading save_data ", error)
		return null
	
	return config_file
