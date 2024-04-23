extends Control
class_name InventoryHUDRelicComponent

## HUD component which deals with the relics

var relic_display : PackedScene = preload("res://InventoryComponents/InventoryHUD/relic_display.tscn")
var relic_display_array : Array[InventoryHUDRelicDisplay]
@onready var relic_start_pos : Node = $StartPos
@export var relic_space : float
var _relic_array : Array[Relic] = []

func _ready() -> void:
	_relic_array += InventoryManager.relic_component.get_held_relics()
	update_relic_display()

func add_relic_to_display(relic : Relic, is_added : bool) -> void:
	if(relic != null):
		if(is_added):
			_relic_array.append(relic)
		else:
			_relic_array.erase(relic)
	update_relic_display()


## updates the relics that are displayed
func update_relic_display() -> void:
	for relic_display_instance in relic_display_array:
		relic_display_instance.queue_free()
	
	relic_display_array.clear()
	
	var pos : Vector2 = relic_start_pos.position
	
	for relic_instance in _relic_array:
		var relic_display_instance : InventoryHUDRelicDisplay = relic_display.instantiate()
		relic_display_array.append(relic_display_instance)
		relic_display_instance.position = pos
		add_child(relic_display_instance)
		relic_display_instance.set_relic(relic_instance)
		pos += Vector2.DOWN * relic_space
