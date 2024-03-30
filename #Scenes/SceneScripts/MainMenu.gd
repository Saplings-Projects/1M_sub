extends Control



func _on_start_pressed() -> void:
	SceneManager.goto_scene("res://#Scenes/TestingScene.tscn")


func _on_options_pressed() -> void:
	SceneManager.goto_scene("res://#Scenes/OptionsMenu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
