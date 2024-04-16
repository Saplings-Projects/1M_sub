extends Control

func _on_add_gold_button_pressed() -> void:
	InventoryManager.gold_component.add_gold(10)



func _on_lose_gold_button_pressed() -> void:
	InventoryManager.gold_component.lose_gold(10)



func _on_get_torch_pressed()-> void:
	InventoryManager.torch_component.get_torches(1)


func _on_lose_torch_pressed()-> void:
	InventoryManager.torch_component.lose_torches(1)


func _on_get_relic_pressed()-> void:
	InventoryManager.relic_component.get_relic(load("res://Items/test_relic.tres"))


func _on_get_consumable_pressed()-> void:
	InventoryManager.consumable_component.get_consumable(load("res://Items/test_consumable.tres"))


func _on_lose_relic_pressed() -> void:
	InventoryManager.relic_component.lose_relic(load("res://Items/test_relic.tres"))


func _on_lose_consumable_slot_pressed() -> void:
	InventoryManager.consumable_component.lose_consumable_max_amount(1)


func _on_get_consumable_slot_pressed() -> void:
	InventoryManager.consumable_component.add_consumable_max_amount(1)
