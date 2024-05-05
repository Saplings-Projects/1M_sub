extends TextureButton
## Button to bring up the map UI

@onready var map_scene: PackedScene = preload("res://#Scenes/MapUI.tscn")

func _pressed() -> void:
	assert(MapManager.is_map_initialized(), "Please instantiate map")
	# The map is part of an overlay, meaning the actual scene in which to instantiate the map is the parent of the overlay
	var parent: Control = $"../.."
	var map: Control = map_scene.instantiate()
	
	parent.add_child(map)
