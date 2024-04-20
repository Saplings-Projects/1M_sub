extends GutTest

func before_each() -> void:
	InventoryManager.reset_inventory()

func test_add_gold() -> void:
	InventoryManager.gold_component.add_gold(10)
	assert_eq(InventoryManager.gold_component.get_gold_amount(), 10)

func test_lose_gold() -> void:
	InventoryManager.gold_component.lose_gold(10)
	assert_eq(InventoryManager.gold_component.get_gold_amount(), -10)

func test_lose_torch() -> void:
	InventoryManager.torch_component.lose_torches(10)
	assert_eq(InventoryManager.torch_component.get_torch_amount(), -10)

func test_add_torch() -> void:
	InventoryManager.torch_component.add_torches(10)
	assert_eq(InventoryManager.torch_component.get_torch_amount(), 10)

func test_add_relic() -> void:
	var test_relic : Relic = load("res://Items/test_relic.tres")
	InventoryManager.relic_component.add_relic(test_relic)
	assert_eq(InventoryManager.relic_component.get_held_relics(), [test_relic])

func test_remove_relic() -> void: 
	var test_relic : Relic = load("res://Items/test_relic.tres")
	InventoryManager.relic_component.add_relic(test_relic)
	InventoryManager.relic_component.add_relic(test_relic)
	InventoryManager.relic_component.add_relic(test_relic)
	InventoryManager.relic_component.lose_relic(test_relic)
	assert_eq(InventoryManager.relic_component.get_held_relics(), [test_relic, test_relic])

func test_add_consumable() -> void:
	var test_consumable : Consumable = load("res://Items/test_consumable.tres")
	InventoryManager.consumable_component.set_consumable_max_amount_to_num(4)
	InventoryManager.consumable_component.add_consumable(test_consumable)
	assert_eq(InventoryManager.consumable_component.get_held_consumables(), [test_consumable, null, null, null])

func test_lose_consumable() -> void:
	var test_consumable : Consumable = load("res://Items/test_consumable.tres")
	InventoryManager.consumable_component.set_consumable_max_amount_to_num(4)
	InventoryManager.consumable_component.add_consumable(test_consumable)
	InventoryManager.consumable_component.add_consumable(test_consumable)
	InventoryManager.consumable_component.add_consumable(test_consumable)
	InventoryManager.consumable_component.remove_consumable_at_place(1)
	assert_eq(InventoryManager.consumable_component.get_held_consumables(), [test_consumable, null, test_consumable, null])

func test_add_consumable_max_amount() -> void:
	InventoryManager.consumable_component.set_consumable_max_amount_to_num(4)
	InventoryManager.consumable_component.add_consumable_max_amount(1)
	assert_eq(InventoryManager.consumable_component.get_max_consumable_amount(), 5)

func test_lose_consumable_max_amount() -> void:
	InventoryManager.consumable_component.set_consumable_max_amount_to_num(4)
	InventoryManager.consumable_component.lose_consumable_max_amount(1)
	assert_eq(InventoryManager.consumable_component.get_max_consumable_amount(), 3)
