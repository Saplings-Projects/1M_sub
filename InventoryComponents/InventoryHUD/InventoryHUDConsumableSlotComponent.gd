extends Control
class_name InventoryHUDConsumableSlotComponent

## This script is responsible for instancing the consumable slots in the InvHUD

var consumable_slots : Array[InventoryHUDConsumableSlot]
@export var consumable_slots_start_pos : Node
var consumable_slot : PackedScene = preload("res://InventoryComponents/InventoryHUD/consumable_slot.tscn")
@export var consumable_slot_space : float

func _ready() -> void:
	_prepare_consumable_slots()

func _prepare_consumable_slots()-> void:
	InventoryManager.consumable_component.consumable_slot_update.connect(_set_consumable_slots)
	InventoryManager.consumable_component.held_consumable_update.connect(set_consumable_in_consumable_slot)
	_set_consumable_slots(InventoryManager.consumable_component.get_max_consumable_amount())

## Instanciates the visual consumable slots in the InvHUD
func _set_consumable_slots(amount : int) -> void:
	for slot in consumable_slots:
		slot.queue_free()
	consumable_slots.clear()
	
	var consumable_slot_amount : int = amount
	var i : int = 0
	# pos is the position in the world the Consumable display wil be places
	var pos : Vector2 = consumable_slots_start_pos.position
	var player_held_consumables : Array[Consumable] = InventoryManager.consumable_component.get_held_consumables()
	
	for slot in consumable_slot_amount:
		var current_consumable_slot : InventoryHUDConsumableSlot = consumable_slot.instantiate() 
		
		add_child(current_consumable_slot)
		current_consumable_slot.pos = i
		current_consumable_slot.position = pos
		consumable_slots.append(current_consumable_slot)
		
		if(player_held_consumables.size() > i):
			current_consumable_slot.set_consumable(player_held_consumables[i])
			
		# moves where the display is drawn, every other wil be placed down
		if(i % 2):
			pos += Vector2.DOWN * consumable_slot_space
			pos.x = consumable_slots_start_pos.position.x
		else:
			pos += Vector2.RIGHT * consumable_slot_space
		i += 1

## fills the consumable slot when player gets an item
func set_consumable_in_consumable_slot(consumable : Consumable, pos : int = -1) -> void:
	if(pos < 0):
		for slot in consumable_slots:
			if(slot.consumable == null):
				pos = slot.pos
				break
	
	consumable_slots[pos].set_consumable(consumable)
	
