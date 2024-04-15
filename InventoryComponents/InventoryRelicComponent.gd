extends Node
class_name InventoryRelicComponent

var held_relics : Array[Relic]

signal held_relics_update(new_relics : Array[Relic])

func get_relic(relic : Relic) -> void:
	held_relics.append(relic)
	held_relics_update.emit(held_relics)

func lose_relic(relic : Relic) -> void:
	held_relics.erase(relic)
	held_relics_update.emit(held_relics)
	pass
