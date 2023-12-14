extends Node
## Initializes randomness for the game.


const GAME_SEED = -1


func _ready() -> void:
	set_game_seed(GAME_SEED)


func set_game_seed(given_seed: int = -1) -> void:
	var set_seed: int = given_seed
	if set_seed == -1:
		set_seed = randi()
	seed(set_seed)
	
	print("Seed set to: " + str(set_seed))
