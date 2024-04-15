class_name InventoryTorchComponent

var current_torches : int = 0
signal torches_updated(new_amount : int)

func get_torches(amount : int) -> void:
	if(amount <= 0):
		return
	
	current_torches += amount
	torches_updated.emit(current_torches)
	pass

func lose_torches(amount : int) -> void:
	if(amount <= 0):
		return
	current_torches -= amount
	torches_updated.emit(current_torches)
	pass
	
func has_torches() -> bool:
	return current_torches > 0
