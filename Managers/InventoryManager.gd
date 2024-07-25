extends Node

## The Inventory Manager is split into part for each item that needs to be held track of [br]
## If a new item is ever needed we can just make a new InventoryComponent and add it to this list [br]
## To get any of the items we can use InventoryManager.example_component.get_example_item()

var gold_component : InventoryGoldComponent = InventoryGoldComponent.new()
var torch_component : InventoryTorchComponent = InventoryTorchComponent.new()
var consumable_component : InventoryConsumablesComponent = InventoryConsumablesComponent.new()
var relic_component : InventoryRelicComponent = InventoryRelicComponent.new()

## This is for the UI [br]
## The current UI is a placeholder and wil be changed in the future

func _ready() -> void:
	SaveManager.start_save.connect(_save_inventory)

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

## Simply just makes new versions of every component class to reset all the items [br]
## The inventory_hud is closed before hand in case something breaks there

func reset_inventory() -> void:
	close_inventory_HUD()
	gold_component = InventoryGoldComponent.new()
	torch_component = InventoryTorchComponent.new()
	consumable_component = InventoryConsumablesComponent.new()
	relic_component = InventoryRelicComponent.new()

func _save_inventory() -> void:
	var config_file: ConfigFile = SaveManager.config_file
	config_file.set_value("InventoryManager", "gold_component", gold_component)
	config_file.set_value("InventoryManager", "torch_component", torch_component)
	config_file.set_value("InventoryManager", "consumable_component", consumable_component)
	config_file.set_value("InventoryManager", "relic_component", relic_component)
	
	var error: Error = config_file.save("user://save_data.ini")
	if error:
		print("Error saving inventory data: ", error)
