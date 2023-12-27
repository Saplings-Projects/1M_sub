extends Control

var card_scene: PackedScene = preload("res://Cards/Card.tscn")

var discard_pile: Array[CardBase] = CardManager.card_container.discard_pile
var draw_pile: Array[CardBase]    = CardManager.card_container.draw_pile
var deck: Array[CardBase]         = CardManager.card_container.default_deck
var cards_to_display: Array[CardBase] = []
var card_worlds: Array[CardWorld] = []
var cardworld: CardWorld = null

func _on_button_pressed() -> void:
	queue_free()

#Pressing escape will return you to the game
func _input(inputevent: InputEvent) -> void:
	if inputevent.is_action("escape"):
		queue_free()



func populate(parent_name: String) -> void:
	
	match parent_name:
		"DiscardPile":
			cards_to_display = discard_pile
			$Label.text = "Showing the discard pile"
		"DrawPile":
			cards_to_display = draw_pile
			$Label.text = "Showing the draw pile"
		"Deck":
			cards_to_display = deck
			$Label.text = "Showing the deck"
		
	
	cards_to_display.sort()

	for card: CardBase in cards_to_display:

		cardworld = card_scene.instantiate()
		$ScrollContainer/GridContainer.add_child(control_cardworld(cardworld))

		cardworld.init_card(card)
	
	


func control_cardworld(card: CardWorld) -> Control:

	var control: Control = Control.new()
	var cardui: Control = card.get_children()[2] # Gets the control node CardUI 

	control.size = cardui.size
	cardui.position =  Vector2(3, 4)
	cardui.scale = Vector2(.7, .7)

	control.add_child(card)

	return control




		
		
		
				
		
	
	
	
