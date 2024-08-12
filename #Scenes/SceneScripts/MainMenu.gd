extends Control
## Control the flow from the main menu

## What happens when the start button is pressed
func _on_start_pressed() -> void:
	# TYTY Clear save data
	#SceneManager.goto_scene("res://#Scenes/MapUI.tscn")
	if not PlayerManager.is_player_initial_position_set:
		SceneManager.goto_scene("res://#Scenes/MapUI.tscn")
	else:
		PlayerManager.clear_data()
		MapManager.clear_map_data()
		XpManager.clear_data()
		CardManager.clear_data()
		InventoryManager.reset_inventory()
		SceneManager.goto_scene("res://#Scenes/MapUI.tscn")

func _on_continue_pressed() -> void:
	if PlayerManager.has_saved_data():
		PlayerManager.load_player()
		MapManager.load_map_data()
		XpManager.load_data()
		CardManager.load_data()
		InventoryManager.load_inventory()
		SceneManager.load_scene_data()

## Scene to be loaded when option button is pressed
func _on_options_pressed() -> void:
	SceneManager.goto_scene("res://#Scenes/OptionsMenu.tscn")


## Kill the game when the quit button is pressed
func _on_quit_pressed() -> void:
	get_tree().quit()
