extends Control

@onready var _gold_text : Label = $CanvasLayer/ColorRect/GoldText
@onready var _torch_text : Label = $CanvasLayer/ColorRect/TorchText
@onready var _relic_component : InventoryHUDRelicComponent = $CanvasLayer/ColorRect/Relics
@onready var _debug_buttons : Control = $CanvasLayer/Buttons
@export var _activate_debug_buttons : bool

## sets the inventory values to display the items in the player inventory 
## as well as conects to signals so that they update  as the inventory does
func _ready() -> void:
	update_gold_text(InventoryManager.gold_component.get_gold_amount())
	update_torch_text(InventoryManager.torch_component.get_torch_amount())
	InventoryManager.gold_component.gold_updated.connect(update_gold_text)
	InventoryManager.torch_component.torches_updated.connect(update_torch_text)
	InventoryManager.relic_component.held_relics_update.connect(_relic_component.update_relic_display)
	
	## removes debug buttons if the bool is set false
	if(!_activate_debug_buttons):
		_debug_buttons.queue_free()


func update_gold_text(new_gold_amount : int) -> void:
	_gold_text.text = "Gold : " + str(new_gold_amount)

func update_torch_text(new_torch_amount : int) -> void:
	_torch_text.text = "Torches : " + str(new_torch_amount)