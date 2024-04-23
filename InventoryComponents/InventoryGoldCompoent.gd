class_name InventoryGoldComponent

var _current_gold : int = 0
signal gold_changed(new_amount : int)

func add_gold(amount : int) -> void:
	if(amount <= 0):
		return
	
	_current_gold += amount
	gold_changed.emit(_current_gold)
	pass

func lose_gold(amount : int) -> void:
	if(amount <= 0):
		return
	_current_gold -= amount
	
	if(_current_gold < 0):
		_current_gold = 0
	
	gold_changed.emit(_current_gold)
	pass

func can_afford(amount : int) -> bool:
	return amount <= _current_gold

func get_gold_amount() -> int:
	return _current_gold
