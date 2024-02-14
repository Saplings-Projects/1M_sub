extends Control
class_name RoomUI

var room: RoomBase
@export var label: Label
@export var color_rect: ColorRect
@export var player_icon: TextureRect

var floor_index: int = 0
var room_index: int = 0

func _ready():
	if room != null:
		if !room.on_light_level_changed.is_connected(_update_room_UI):
			room.on_light_level_changed.connect(_update_room_UI)
		_update_room_UI()

func set_label(title: String):
	label.set_text(title)

func set_player_icon(enabled: bool) -> void:
	player_icon.visible = enabled

func has_player() -> bool:
	return player_icon.visible


func _update_room_UI():
	var alpha = 0
	match (room.light_level):
		Enums.LightLevel.UNLIT:
			alpha = 1
		Enums.LightLevel.DIMLY_LIT:
			alpha = 0.5
		Enums.LightLevel.LIT:
			alpha = 0.25
		Enums.LightLevel.BRIGHTLY_LIT:
			alpha = 0
	color_rect.color = Color(0, 0, 0, alpha)
