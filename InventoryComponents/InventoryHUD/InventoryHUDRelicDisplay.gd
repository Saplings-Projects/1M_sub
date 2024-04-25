extends Control
class_name InventoryHUDRelicDisplay
  
## an item instanced for the inventoryHUD

@export var textureRect : TextureRect

func set_relic(relic : Relic) -> void:
	textureRect.texture = load(relic.sprite_path)
