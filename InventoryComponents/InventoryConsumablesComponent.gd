class_name InventoryConsumablesComponent

var _held_consumables : Array[Consumable]
var _max_consumable_number : int = 4

##remove consumable from slot by using null as new_consumable
signal held_consumable_update(new_consumable : Consumable, pos : int)
signal consumable_slot_update(new_amount : int)

func _init() -> void:
	_update_consumable_limit()
	consumable_slot_update.connect(_update_consumable_limit)

func add_consumable(consumable : Consumable) -> void:
	var i : int = 0
	
	for consumable_slot in _held_consumables:
		if(consumable_slot == null):
			set_consumable(consumable, i)
			break
		i += 1

func set_consumable(consumable : Consumable, pos : int) -> void:
	_held_consumables[pos] = consumable
	held_consumable_update.emit(consumable, pos)

func remove_consumable_at_place(pos : int) -> void:
	_held_consumables[pos] = null
	held_consumable_update.emit(null, pos)

func use_consumable_at_place(pos : int) -> void:
	if(_held_consumables[pos] == null):
		return
	
	_held_consumables[pos].on_consume()
	remove_consumable_at_place(pos)

func _update_consumable_limit(new_amount : int = _max_consumable_number) -> void:
	while(_held_consumables.size() < new_amount):
		_held_consumables.append(null)
	
	while(_held_consumables.size() > new_amount):
		_held_consumables.pop_back()

func add_consumable_max_amount(amount : int) -> void:
	if(amount <= 0):
		return
	_max_consumable_number += amount
	consumable_slot_update.emit(_max_consumable_number)

func lose_consumable_max_amount(amount : int) -> void:
	if(amount <= 0):
		return
	
	_max_consumable_number -= amount
	
	if(_max_consumable_number < 0):
		_max_consumable_number = 0
	
	consumable_slot_update.emit(_max_consumable_number)

func get_max_consumable_amount() -> int:
	return _max_consumable_number

func get_held_consumables() -> Array[Consumable]:
	return _held_consumables
