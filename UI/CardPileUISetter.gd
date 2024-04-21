extends Node
class_name CardPileUISetter
## Controls what happens when clicking on a card pile
##
## Will load all the cards in the given pile and put them in a grid format

## Which scene to instantiate the grid in, this is important for positioning
@onready var parent: Control

@export var pile_count_label: Label = null
@onready var cardUI: PackedScene = preload("res://#Scenes/CardScrollUI.tscn")

func _ready() -> void:
	parent =  $".."
	if CardManager.card_container != null:
		_on_card_container_initialized()
	else:
		CardManager.on_card_container_initialized.connect(_on_card_container_initialized)


func _on_card_container_initialized() -> void:
	CardManager.card_container.on_card_counts_updated.connect(_on_card_counts_updated)


func _on_card_counts_updated() -> void:
	pile_count_label.text = str(_get_count())


func _get_count() -> int:
	return CardManager.card_container.get_draw_pile_size()

func _pressed() -> void:
	var uiPile: Control = cardUI.instantiate()
	
	uiPile.populate(get_name())
	parent.add_child(uiPile)
