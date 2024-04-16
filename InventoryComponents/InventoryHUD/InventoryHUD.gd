extends Control

@onready var _gold_text : Label = $CanvasLayer/ColorRect/GoldText
@onready var _torch_text : Label = $CanvasLayer/ColorRect/TorchText
@onready var _relic_component : InventoryHUDRelicComponent = $CanvasLayer/ColorRect/Relics
@onready var _debug_buttons : Control = $CanvasLayer/Buttons
@export var _activate_debug_buttons : bool

func _ready() -> void:
	update_gold_text(InventoryManager.gold_component.current_gold)
	update_torch_text(InventoryManager.torch_component.current_torches)
	InventoryManager.gold_component.gold_updated.connect(update_gold_text)
	InventoryManager.torch_component.torches_updated.connect(update_torch_text)
	InventoryManager.relic_component.held_relics_update.connect(_relic_component.update_relic_displays)
	if(!_activate_debug_buttons):
		_debug_buttons.queue_free()


func update_gold_text(new_gold_amount : int) -> void:
	_gold_text.text = "Gold : " + str(new_gold_amount)

func update_torch_text(new_torch_amount : int) -> void:
	_torch_text.text = "Torches : " + str(new_torch_amount)
