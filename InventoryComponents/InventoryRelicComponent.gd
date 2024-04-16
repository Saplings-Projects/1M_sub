class_name InventoryRelicComponent

var _held_relics : Array[Relic]

#is_added bool wil be true if you're adding the relic and false if you're removing it
signal held_relics_update(relic : Relic, is_added : bool)

func add_relic(relic : Relic) -> void:
	_held_relics.append(relic)
	held_relics_update.emit(relic, true)

func lose_relic(relic : Relic) -> void:
	_held_relics.erase(relic)
	held_relics_update.emit(relic, false)
	pass

func get_held_relics() -> Array[Relic]:
	return _held_relics
