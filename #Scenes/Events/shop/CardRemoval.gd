extends CardPileUISetter

@onready var priceText : Label = $CardRemoval/ColorRect/Label

func _ready() -> void:
	priceText.text = str(ShopManager.card_removal_price)
	super()

func _pressed() -> void:
	if(!InventoryManager.gold_component.can_afford(ShopManager.card_removal_price)):
		return
	
	
	var uiPile: Control = cardUI.instantiate()
	
	uiPile.populate(get_name())
	parent.add_child(uiPile)
	queue_free()

func _on_button_pressed() -> void:
	
	pass 
