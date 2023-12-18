extends Button
## Shows an UI for the player to see the content of that specific Card Pile

@onready var parent_node = $".."
var scene: PackedScene = preload("res://#Scenes/card_pile_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(parent_node.get_name())
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _pressed():
	var instance = scene.instantiate()
	add_child(instance)
