extends Button
## Shows an UI for the player to see the content of that specific Card Pile

@onready var parent_node = $".."
@onready var root = parent_node.get_parent()
@onready var cardUI: PackedScene = preload("res://#Scenes/card_pile_ui.tscn")

	
func _pressed() -> void:
	#print(parent_node.get_name())
	var uiPile = cardUI.instantiate()
	uiPile.populate(parent_node.get_name())
	root.add_child(uiPile)
	
	

	
