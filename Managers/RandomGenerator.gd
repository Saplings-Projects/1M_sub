extends Node


var random: RandomNumberGenerator = null


func _ready() -> void:
	random = RandomNumberGenerator.new()
	random.seed = randi()
	
	print("Random seed set to: " + str(random.seed))
	
	random.randomize()
