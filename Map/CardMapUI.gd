extends Control

var _current_map: MapBase

func _ready():
	_current_map = MapManager.current_map
