class_name InventoryGoldComponent

var current_gold : int = 0
signal gold_updated(new_amount : int)

func add_gold(amount : int) -> void:
	if(amount <= 0):
		return
	
	current_gold += amount
	gold_updated.emit(current_gold)
	pass

func lose_gold(amount : int) -> void:
	if(amount <= 0):
		return
	current_gold -= amount
	gold_updated.emit(current_gold)
	pass

func can_afford(amount : int) -> bool:
	return amount <= current_gold
	
