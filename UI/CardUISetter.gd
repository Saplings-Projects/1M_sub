extends Control
class_name CardUISetter
## Handles setting up UI on a card by pulling from CardBase card_data.
##
## The idea with using a UI setter like this is we don't have any references to UI stuff
## in the actual Card class, so we can keep that class as minimal as possible.


@export var title_label: Label
@export var description_label: Label
@export var energy_label: Label
@export var key_art: TextureRect


func _ready() -> void:
	var parent_card: CardWorld = get_parent() as CardWorld
	
	assert(parent_card != null, "Couldn't find parent card. Make sure this is attached to a card.")
	
	# wait for data to initialize if needed
	if parent_card.card_data != null:
		_on_card_initialized(parent_card.card_data)
	else:
		parent_card.on_card_data_initialized.connect(_on_card_initialized)


func _on_card_initialized(in_card_data: CardBase) -> void:
	title_label.text = in_card_data.card_title
	description_label.text = in_card_data.card_description
	energy_label.text = "E: " + str(in_card_data.energy_cost)
	if in_card_data.card_key_art:
		key_art.texture = in_card_data.card_key_art
	else:
		push_warning("No key art set in the card data. Using default")
