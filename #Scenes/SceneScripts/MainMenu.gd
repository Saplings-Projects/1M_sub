extends Control
## Control the flow from the main menu

## What happens when the start button is pressed
func _on_start_pressed() -> void:
	if not PlayerManager.is_player_initial_position_set:
		SceneManager.goto_scene("res://#Scenes/MapUI.tscn")
	else:
		# TODO : load the last scene the player was in
		pass

func _on_continue_pressed() -> void:
	if PlayerManager.has_saved_data():
		SceneManager.load_scene_data()
		#SceneManager.goto_scene("res://#Scenes/MapUI.tscn")

## Scene to be loaded when option button is pressed
func _on_options_pressed() -> void:
	SceneManager.goto_scene("res://#Scenes/OptionsMenu.tscn")


## Kill the game when the quit button is pressed
func _on_quit_pressed() -> void:
	get_tree().quit()
