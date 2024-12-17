extends Node

@onready var gallery_item_scene: PackedScene = preload("res://#Scenes/GalleryItem.tscn")

func _ready() -> void:
	pass

func _back_to_main_menu_pressed() -> void:
	SceneManager.goto_scene("res://#Scenes/MainMenu.tscn")

func _go_to_gallery_item() -> void:
	var gallery_item: Node2D = gallery_item_scene.instantiate()
	
	get_parent().add_child(gallery_item)
