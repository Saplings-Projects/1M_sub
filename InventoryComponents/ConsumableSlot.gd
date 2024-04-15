extends Control
class_name ConsumableSlot

var consumable : Consumable = null
var pos : int 
@export var texture_rect : TextureRect

func set_consumable(new_consumable : Consumable) -> void:
	consumable = new_consumable
	if(consumable != null):
		texture_rect.texture = load(consumable.image_path)
	else:
		texture_rect.texture = load("res://Art/Items/Empty_consumable.png")


func _on_button_pressed() -> void:
	InventoryManager.consumable_component.consume_consumable_at_place(pos)
	pass # Replace with function body.
