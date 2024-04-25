class_name InventoryRelicComponent
## Inventory component responsible for relics

var _held_relics : Array[Relic]

#is_added bool will be true if you're adding the relic and false if you're removing it
signal held_relics_changed(relic : Relic, is_added : bool)

func add_relic(relic : Relic) -> void:
	_held_relics.append(relic)
	held_relics_changed.emit(relic, true)

func lose_relic(relic : Relic) -> void:
	_held_relics.erase(relic)
	held_relics_changed.emit(relic, false)
	pass

func get_held_relics() -> Array[Relic]:
	return _held_relics
