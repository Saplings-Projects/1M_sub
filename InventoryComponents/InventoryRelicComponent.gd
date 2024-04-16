class_name InventoryRelicComponent

var held_relics : Array[Relic]

#is_added bool wil be true if you're adding the relic and false if you're removing it
signal held_relics_update(relic : Relic, is_added : bool)

func add_relic(relic : Relic) -> void:
	held_relics.append(relic)
	held_relics_update.emit(relic, true)

func lose_relic(relic : Relic) -> void:
	held_relics.erase(relic)
	held_relics_update.emit(relic, false)
	pass
