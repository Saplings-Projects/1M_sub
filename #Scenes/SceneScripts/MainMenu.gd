extends Control
## Control the flow from the main menu

var continue_button: TextureButton
@export var start_new_game_dialog: ConfirmationDialog

#on opening the main menu we grab the focus of the start button
func _ready() -> void:
	$"Menu buttons/Continue".grab_focus()
	$"game version".text = ProjectSettings.get_setting("application/config/version")
	for child in get_node("Menu buttons").get_children():
		if child.name == "Continue":
			continue_button = child
		child.mouse_entered.connect(_on_button_hovered.bind(child))
	if !PlayerManager.has_saved_data():
		continue_button.disabled = true
	

## What happens when the start button is pressed
func _on_start_pressed() -> void:
	if PlayerManager.has_saved_data():
		start_new_game_dialog.show()
	else:
		MapManager.init_data()
		SceneManager.goto_scene("res://#Scenes/MapUI.tscn")

func _on_continue_pressed() -> void:
	if PlayerManager.has_saved_data():
		PlayerManager.load_player()
		MapManager.load_map_data()
		XpManager.load_data()
		CardManager.load_data()
		InventoryManager.load_inventory()
		SceneManager.load_scene_data()

func _on_button_hovered(button: TextureButton) -> void:
	button.grab_focus()

## Scene to be loaded when option button is pressed
func _on_options_pressed() -> void:
	SceneManager.goto_scene("res://#Scenes/OptionsMenu.tscn")


## Kill the game when the quit button is pressed
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_new_game_dialog_confirmed() -> void:
	SaveManager.clear_data()
	MapManager.init_data()
	PlayerManager.init_data()
	XpManager.init_data()
	CardManager.init_data()
	InventoryManager.init_data()
	SceneManager.goto_scene("res://#Scenes/MapUI.tscn")
