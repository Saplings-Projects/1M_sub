class_name InventoryGoldComponent

var current_gold : int = 0

func add_gold(amount : int) -> void:
	if(amount <= 0):
		return
	
	current_gold += amount
	pass

func lose_gold(amount : int) -> void:
	if(amount <= 0):
		return
	current_gold -= amount
	pass
