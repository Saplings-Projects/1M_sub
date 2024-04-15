extends Control

@export var gold_text : Label
@export var torch_text : Label
@export var consumableComponent : ConsumableSlotCompoent
@export var relicComponent : InventoryHUDRelicComponent

func _ready() -> void:
	update_gold_text(InventoryManager.gold_component.current_gold)
	update_torch_text(InventoryManager.torch_component.current_torches)
	InventoryManager.gold_component.gold_updated.connect(update_gold_text)
	InventoryManager.torch_component.torches_updated.connect(update_torch_text)
	consumableComponent.prepare_consumable_slots()
	InventoryManager.relicComponent.held_relics_update.connect(relicComponent.update_relic_displays)

func update_gold_text(new_gold:int) -> void:
	gold_text.text = "Gold : " + str(new_gold)

func update_torch_text(new_torch:int) -> void:
	torch_text.text = "Torches : " + str(new_torch)
