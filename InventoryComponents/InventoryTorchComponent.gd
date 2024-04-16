class_name InventoryTorchComponent

var torch_amount : int = 0
signal torches_updated(new_amount : int)

func add_torches(amount : int) -> void:
	if(amount <= 0):
		return
	
	torch_amount += amount
	torches_updated.emit(torch_amount)
	pass

func lose_torches(amount : int) -> void:
	if(amount <= 0):
		return
	torch_amount -= amount
	torches_updated.emit(torch_amount)
	pass
	
func has_torches() -> bool:
	return torch_amount > 0
