extends Node

signal start_save
signal load_data

var config_file: ConfigFile

func _ready() -> void:
	config_file = ConfigFile.new()

func execute_save() -> void:
	start_save.emit()

func clear_data() -> void:
	config_file.clear()
	var error: Error = config_file.save("user://save_data.ini")
	if error:
		print("Error saving player data: ", error)
