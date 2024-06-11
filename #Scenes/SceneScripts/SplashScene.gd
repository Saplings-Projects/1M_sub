extends Control

@export var timer: Timer

func _ready() -> void:
	timer.connect("timeout", _on_timer_finish)
	
	timer.start()
	print("Start the thing")

func _on_timer_finish() -> void:
	print("go to next scene")
	SceneManager.goto_scene("res://#Scenes/MainMenu.tscn")
