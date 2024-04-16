extends Control
class_name InventoryHUDRelicComponent

var relic_display : PackedScene = preload("res://InventoryComponents/InventoryHUD/relic_display.tscn")
var relic_display_array : Array[InventoryHUDRelicDisplay]
@export var relic_start_pos : Node
@export var relic_space : float

func update_relic_displays(relics_array : Array[ Relic]) -> void:
	for relic_display_instance in relic_display_array:
		relic_display_instance.queue_free()
	
	relic_display_array.clear()
	var pos : Vector2 = relic_start_pos.position
	
	for relic in relics_array:
		var relic_display_instance : InventoryHUDRelicDisplay = relic_display.instantiate()
		relic_display_array.append(relic_display_instance)
		relic_display_instance.position = pos
		add_child(relic_display_instance)
		relic_display_instance.set_relic(relic)
		pos += Vector2.DOWN * relic_space
