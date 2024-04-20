class_name InventoryTorchComponent

var _torch_amount : int = 0
signal torches_changed(new_amount : int)

func add_torches(amount : int) -> void:
	if(amount <= 0):
		return
	
	_torch_amount += amount
	torches_changed.emit(_torch_amount)
	pass

func lose_torches(amount : int) -> void:
	if(amount <= 0):
		return
	
	_torch_amount -= amount
	torches_changed.emit(_torch_amount)
	pass

func get_torch_amount() -> int:
	return _torch_amount

func has_torches() -> bool:
	return _torch_amount > 0
