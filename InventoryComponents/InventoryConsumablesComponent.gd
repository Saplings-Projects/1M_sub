class_name InventoryConsumablesComponent

var held_consumables : Array[Consumable]
var max_consumable_number : int = 4

signal held_consumable_update(new_consumable : Consumable, pos : int)
signal consumable_slot_update(new_amount : int)

func _init() -> void:
	_update_consumable_limit()
	consumable_slot_update.connect(_update_consumable_limit)

func get_consumable(consumable : Consumable) -> void:
	var i : int = 0
	
	for consumable_slot in held_consumables:
		if(consumable_slot == null):
			set_consumable(consumable, i)
			break
		i += 1

func set_consumable(consumable : Consumable, pos : int) -> void:
	held_consumables[pos] = consumable
	held_consumable_update.emit(consumable, pos)

func remove_consumable_at_place(pos : int) -> void:
	held_consumables[pos] = null
	held_consumable_update.emit(null, pos)
	pass

func consume_consumable_at_place(pos : int) -> void:
	if(held_consumables[pos] == null):
		return
	
	held_consumables[pos].on_consume()
	remove_consumable_at_place(pos)
	pass

func _update_consumable_limit(new_amount : int = max_consumable_number) -> void:
	while(held_consumables.size() < new_amount):
		held_consumables.append(null)
	
	while(held_consumables.size() > new_amount):
		held_consumables.pop_back()

func get_consumable_slot(amount : int) -> void:
	if(amount <= 0):
		return
	max_consumable_number += amount
	consumable_slot_update.emit(max_consumable_number)

func lose_consumable_slot(amount : int) -> void:
	if(amount <= 0):
		return
	
	max_consumable_number -= amount
	
	if(max_consumable_number < 0):
		max_consumable_number = 0
	
	consumable_slot_update.emit(max_consumable_number)
