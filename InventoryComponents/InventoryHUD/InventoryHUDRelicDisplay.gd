extends Control
class_name InventoryHUDRelicDisplay

@export var textureRect : TextureRect

func set_relic(relic : Relic) -> void:
	textureRect.texture = load(relic.sprite_path)
