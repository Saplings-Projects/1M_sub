extends Control

var room: RoomBase
@export var label: Label

func set_label(title: String):
	label.set_text(title)
