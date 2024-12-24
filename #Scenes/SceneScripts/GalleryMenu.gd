extends Node

@onready var gallery_item_scene: PackedScene = preload("res://#Scenes/GalleryItem.tscn")
@onready var card: PackedScene = preload("res://Cards/Card.tscn")

@export var mobs_box_tab: Control
@export var mobs_list: Array[GalleryArtInfo]

@export var cards_box_tab: Control

func _ready() -> void:
	_populate_mobs_tab()
	_populate_cards_tab()

func _back_to_main_menu_pressed() -> void:
	SceneManager.goto_scene("res://#Scenes/MainMenu.tscn")

func _go_to_gallery_item(gallery_info: GalleryInfo) -> void:
	var gallery_item: GalleryItem = gallery_item_scene.instantiate()
	gallery_item.gallery_info = gallery_info
	
	get_parent().add_child(gallery_item)

func _populate_mobs_tab() -> void:
	var mob_texture_button_size: Vector2 = Vector2(400, 400)
	for mobs in mobs_list:
		var texture_button: TextureButton = TextureButton.new()
		texture_button.ignore_texture_size = true
		texture_button.stretch_mode = TextureButton.STRETCH_SCALE
		texture_button.custom_minimum_size = mob_texture_button_size
		texture_button.texture_normal = mobs.texture
		texture_button.pressed.connect(_go_to_gallery_item.bind(mobs))
		mobs_box_tab.add_child(texture_button)

func _populate_cards_tab() -> void:
	var cards_list: Array[GalleryCardInfo]
	for card_resource_file in DirAccess.get_files_at("res://Cards/Resource/"):
		var gallery_card_info: GalleryCardInfo = GalleryCardInfo.new()
		gallery_card_info.card_resource = load("res://Cards/Resource/" + card_resource_file)
		cards_list.append(gallery_card_info)

	for cards in cards_list:
		var card_world: CardWorld = card.instantiate()
		card_world.card_data = load(cards.card_resource.resource_path)
		card_world.get_click_handler().on_click.connect(_go_to_gallery_item.bind(cards))
		cards_box_tab.add_child(card_world)
