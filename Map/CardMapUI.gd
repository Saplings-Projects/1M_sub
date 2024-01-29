extends Control

var _current_map: MapBase

func _ready():
	_current_map = MapManager.current_map
	
func _on_return_button_press():
	queue_free()
