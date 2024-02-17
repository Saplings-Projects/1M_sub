extends Control
class_name RoomUI

var room: RoomBase
@export var label: Label
@export var color_rect: ColorRect
@export var player_icon: TextureRect
var light_node: LightNode

var floor_index: int = 0
var room_index: int = 0

func set_label(title: String) -> void:
	label.set_text(title)

func toggle_player_icon(enabled: bool) -> void:
	player_icon.visible = enabled
	room.set_light_level(Enums.LightLevel.DIMLY_LIT)

func has_player() -> bool:
	return player_icon.visible

func get_light_level() -> Enums.LightLevel:
	return room.light_level
