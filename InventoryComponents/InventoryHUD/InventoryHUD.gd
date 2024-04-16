extends Control

@onready var _gold_text : Label = $CanvasLayer/ColorRect/GoldText
@onready var _torch_text : Label = $CanvasLayer/ColorRect/TorchText
@onready var _relic_component : InventoryHUDRelicComponent = $CanvasLayer/ColorRect/Relics

func _ready() -> void:
	update_gold_text(InventoryManager.gold_component.current_gold)
	update_torch_text(InventoryManager.torch_component.current_torches)
	InventoryManager.gold_component.gold_updated.connect(update_gold_text)
	InventoryManager.torch_component.torches_updated.connect(update_torch_text)
	InventoryManager.relic_component.held_relics_update.connect(_relic_component.update_relic_displays)

func update_gold_text(new_gold:int) -> void:
	_gold_text.text = "Gold : " + str(new_gold)

func update_torch_text(new_torch:int) -> void:
	_torch_text.text = "Torches : " + str(new_torch)
