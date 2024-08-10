extends Control
## Control the flow from the main menu

#on opening the main menu we grab the focus of the start button
func _ready() -> void:
	$"Menu buttons/Continue".grab_focus()
	$"game version".text = ProjectSettings.get_setting("application/config/version")
	for child in get_node("Menu buttons").get_children():
			child.mouse_entered.connect(_on_button_hovered.bind(child))

## What happens when the start button is pressed
func _on_start_pressed() -> void:
	if not PlayerManager.is_player_initial_position_set:
		SceneManager.goto_scene("res://#Scenes/MapUI.tscn")
	else:
		# TODO : load the last scene the player was in
		pass

func _on_button_hovered(button: TextureButton) -> void:
	button.grab_focus()

## Scene to be loaded when option button is pressed
func _on_options_pressed() -> void:
	SceneManager.goto_scene("res://#Scenes/OptionsMenu.tscn")


## Kill the game when the quit button is pressed
func _on_quit_pressed() -> void:
	get_tree().quit()
