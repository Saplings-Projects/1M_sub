extends Node2D
class_name GalleryItem

@onready var card: PackedScene = preload("res://Cards/Card.tscn")

# Take in information of type of material to show
# Card, Art, or Sapling Message
# Create Different objects for the different materials, then show/hide based on the material we want to show
@export var art_texture_node: TextureRect
@export var art_author: Label
@export var art_scroll_container: Control

var gallery_info: GalleryInfo = null

func _ready() -> void:
	if gallery_info is GalleryArtInfo:
		art_scroll_container.visible = true
		art_author.text = "Art by: " + gallery_info.author
		art_texture_node.texture = gallery_info.texture
	elif gallery_info is GalleryCardInfo:
		var card_world: CardWorld = card.instantiate()
		card_world.card_data = load(gallery_info.card_resource.resource_path)
		card_world.position = Vector2(590, 60)
		card_world.scale = Vector2(2, 2)
		add_child(card_world)

func _back_to_gallery() -> void:
	queue_free()
