extends Control

@onready var gridcontainer: GridContainer = $GridContainer
@onready var parent_node = $".."

#I wanted to use pure_card as card_scene is used in (https://github.com/Paper-2/1M_sub/blob/bc1048d2eddec7aa6205d1bc2be40c519858b40a/Cards/CardContainer.gd#L117-L125)
@onready var pure_card: PackedScene

var discard_pile: Array[CardBase] = CardManager.card_container.discard_pile
var draw_pile: Array[CardBase]    = CardManager.card_container.draw_pile
var deck: Array[CardBase]         = CardManager.card_container.default_deck
var cards_to_display: Array[CardBase]


# TODO bind esc to return to the game
func _on_button_pressed():
	queue_free()


#Im open for suggestions with the name of this fuction 
func populate(parent_name):
	


	if parent_name == "DiscardPile":
		cards_to_display = discard_pile
	elif parent_name == "DrawPile":
		cards_to_display = draw_pile

	elif parent_name == "PLACEHOLDER":
		pass


	#
	for card in cards_to_display:
		var cardworld: CardWorld = CardWorld.new()

		#var cardworld: CardWorld = pure_card.instantiate() This line also gives an error :WideFauna2:
		print(card, cardworld)
		
		#Why doesn't this line work? I Keep getting the error Cannot call method 'add_child' on a null value.
		#gridcontainer.add_child(cardworld)

		$GridContainer.add_child(cardworld)

		#the card gets initialize yet its node doesn't show up in the screen
		cardworld.init_card(card)

		
		
	
	
	

