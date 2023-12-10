extends Node
## Initializes randomness for the game.


func _ready() -> void:
	var seed: int = randi()
	seed(seed)
	
	print("Random seed set to: " + str(seed))
