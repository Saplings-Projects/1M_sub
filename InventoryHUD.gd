extends Control

@export var gold_text : Label

func _ready() -> void:
	gold_text.text = str(InventoryManager.gold_component.current_gold)
	pass # Replace with function body.

func _process(_delta : float) -> void:
	gold_text.text = str(InventoryManager.gold_component.current_gold)
	pass # Replace with function body.
