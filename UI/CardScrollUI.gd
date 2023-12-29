extends Control

var card_scene: PackedScene = preload("res://Cards/Card.tscn")

var discard_pile: Array[CardBase] = CardManager.card_container.discard_pile
var draw_pile: Array[CardBase]    = CardManager.card_container.draw_pile
var deck: Array[CardBase]         = CardManager.card_container.default_deck
var cards_to_display: Array[CardBase] = []
var card_worlds: Array[CardWorld] = []
var cardworld: CardWorld = null
var cardui: Control = null

const CARD_SCALE: Vector2 = Vector2(.7, .7)
const CARDUI_INDEX: int = 2
const CARDUI_POS: Vector2 = Vector2(4,4)
const SIZE_OFFSET: Vector2 = Vector2(10,10)

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
		"DeckPile":
			cards_to_display = deck
			$Label.text = "Showing the deck"
		
	
	cards_to_display.sort()

	for card: CardBase in cards_to_display:

		cardworld = card_scene.instantiate()
		cardui = cardworld.get_child(CARDUI_INDEX)

		cardworld.custom_minimum_size = (cardui.size * CARD_SCALE) + SIZE_OFFSET
		cardui.scale = CARD_SCALE
		cardui.anchors_preset = CORNER_TOP_LEFT
		cardui.position = CARDUI_POS

		$ScrollContainer/GridContainer.add_child(cardworld)
		print(cardworld.custom_minimum_size)
		cardworld.init_card(card)





		
		
		
				
		
	
	
	
