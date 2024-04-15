class_name InventoryConsumablesComponent

var held_consumables : Array[Consumable]
var consumables_limit : int = 4

signal held_consumable_update(new_consumable : Consumable, pos : int)
signal consumable_slot_update(new_amount : int)

func get_consumable(consumable : Consumable) -> void:
	prepare_consumable_array()
	
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
	prepare_consumable_array()
	
	if(held_consumables[pos] == null):
		return
	
	held_consumables[pos].on_consume()
	remove_consumable_at_place(pos)
	pass

func prepare_consumable_array() -> void:
	while(held_consumables.size() < consumables_limit):
		held_consumables.append(null)
	
	while(held_consumables.size() > consumables_limit):
		held_consumables.pop_back()

func get_consumable_slot(amount : int) -> void:
	if(amount <= 0):
		return
	consumables_limit += amount
	prepare_consumable_array()
	consumable_slot_update.emit(consumables_limit)

func lose_consumable_slot(amount : int) -> void:
	if(amount <= 0):
		return
	
	consumables_limit -= amount
	
	if(consumables_limit < 0):
		consumables_limit = 0
	
	prepare_consumable_array()
	consumable_slot_update.emit(consumables_limit)
