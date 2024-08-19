extends Node2D

## * We do this to properly init the battle state
## Before, the testing scene was the main scene so it was properly started by the phase manager
## Now that the main scene is the main menu and we load the testing scene from there, we init to properly init the game state 

func _ready() -> void:
	# TYTY bug here where it doubles saves and when it doubles saves it replaces the map w/ no light
	SaveManager.execute_save()
	PhaseManager.initialize_game()
