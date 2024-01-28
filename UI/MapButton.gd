extends TextureButton
# Button to bring up the map UI

@onready var map_scene: PackedScene = preload("res://#Scenes/MapUI.tscn")

func _pressed():
	assert(MapManager.is_map_initialized(), "Please instantiate map")
	var parent: Control = $".."
	var map: Control = map_scene.instantiate()
	
	#map.populate(get_name())
	parent.add_child(map)
