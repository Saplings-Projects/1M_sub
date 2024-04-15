extends Node

var gold_component : InventoryGoldComponent = InventoryGoldComponent.new()
var torch_component : InventoryTorchComponent = InventoryTorchComponent.new()
var consumable_component : InventoryConsumablesComponent = InventoryConsumablesComponent.new()
@export var relicComponent : InventoryRelicComponent = InventoryRelicComponent.new()

var inventory_HUD : PackedScene = preload("res://InventoryComponents/inventory_hud.tscn")
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
