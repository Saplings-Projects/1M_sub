extends Control
class_name ConsumableSlotCompoent

var consumable_slots : Array[ConsumableSlot]
@export var consumable_slots_start_pos : Node
var consumable_slot : PackedScene = preload("res://InventoryComponents/consumable_slot.tscn")
@export var consumable_slot_space : float

func prepare_consumable_slots()-> void:
	InventoryManager.consumable_component.consumable_slot_update.connect(set_consumable_slots)
	InventoryManager.consumable_component.held_consumable_update.connect(set_consumable_in_consumable_slot)
	set_consumable_slots(InventoryManager.consumable_component.consumables_limit)

func set_consumable_slots(amount : int) -> void:
	for slot in consumable_slots:
		slot.queue_free()
	consumable_slots.clear()
	
	var consumable_slot_amount : int = amount
	var i : int = 0
	var pos : Vector2 = consumable_slots_start_pos.position
	for slot in consumable_slot_amount:
		var current_consumable_slot : ConsumableSlot = consumable_slot.instantiate() 
		add_child(current_consumable_slot)
		current_consumable_slot.pos = i
		current_consumable_slot.position = pos
		consumable_slots.append(current_consumable_slot)
		if(InventoryManager.consumable_component.held_consumables.size() > i):
			current_consumable_slot.set_consumable(InventoryManager.consumable_component.held_consumables[i])
		if(i % 2):
			pos += Vector2.DOWN * consumable_slot_space
			pos.x = consumable_slots_start_pos.position.x
		else:
			pos += Vector2.RIGHT * consumable_slot_space
		i += 1
	pass

func set_consumable_in_consumable_slot(consumable : Consumable, pos : int = -1) -> void:
	if(pos < 0):
		for slot in consumable_slots:
			if(slot.consumable == null):
				pos = slot.pos
				break
	
	consumable_slots[pos].set_consumable(consumable)
	
