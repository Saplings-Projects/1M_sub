extends Control

var map_scene: PackedScene = preload("res://#Scenes/MapUI.tscn")

func _input(_inputevent: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		queue_free()
