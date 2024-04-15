extends Button

@export var con : Relic


func _on_pressed() -> void:
	InventoryManager.toggle_inventory_HUD()
	pass # Replace with function body.

