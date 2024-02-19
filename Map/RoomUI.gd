extends Control

var room: RoomBase
@export var label: Label
@export var button: TextureButton


func _ready():
	button.pressed.connect(_set_player_position_based_on_room)

func set_label(title: String):
	label.set_text(title)
	
func _set_player_position_based_on_room():
	PlayerManager.player_position = room.room_position
	SignalBus.clicked_next_room_on_map.emit()
