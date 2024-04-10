extends Node

var gold_component : InventoryGoldComponent = InventoryGoldComponent.new()

var inventory_HUD : PackedScene = preload( "res://inventory_hud.tscn")

func _ready() -> void:
	add_child( inventory_HUD.instantiate())
	
	print("test")
