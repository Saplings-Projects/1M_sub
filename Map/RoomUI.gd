extends Control

var room: RoomBase
var label: Label

func _ready():
	label = get_child(0).get_child(0)

func set_label(title: String):
	label.set_text(title)
