extends Node

var gold_component : InventoryGoldComponent = InventoryGoldComponent.new()
var torch_component : InventoryTorchComponent = InventoryTorchComponent.new()
var consumable_component : InventoryConsumablesComponent = InventoryConsumablesComponent.new()
var relic_component : InventoryRelicComponent = InventoryRelicComponent.new()

var inventory_HUD : PackedScene = preload("res://InventoryComponents/InventoryHUD/inventory_hud.tscn")
var instanced_inventory_HUD : Node

func instance_inventory_HUD() -> void:
	instanced_inventory_HUD = inventory_HUD.instantiate()
	add_child(instanced_inventory_HUD)

func close_inventory_HUD() -> void:
	if(instanced_inventory_HUD == null):
		return
	
	instanced_inventory_HUD.queue_free()

func toggle_inventory_HUD() -> void:
	if(instanced_inventory_HUD == null):
		instance_inventory_HUD()
	else:
		close_inventory_HUD()

func reset_inventory() -> void:
	close_inventory_HUD()
	gold_component = InventoryGoldComponent.new()
	torch_component = InventoryTorchComponent.new()
	consumable_component = InventoryConsumablesComponent.new()
	relic_component = InventoryRelicComponent.new()
