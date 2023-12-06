extends Node
## Unused. Allows you to drag a card around instead of clicking and queuing.


var is_dragging: bool = false
var dragging_object: Node2D = null

func _process(_delta) -> void:
	if dragging_object != null:
		dragging_object.global_position = dragging_object.get_global_mouse_position()
		if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			set_dragging(null)


func set_dragging(in_dragging_object: Node2D) -> void:
	if in_dragging_object == null:
		is_dragging = false
		dragging_object = null
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		is_dragging = true
		dragging_object = in_dragging_object
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func is_dragging_object(in_object: Node2D) -> bool:
	return in_object == dragging_object
