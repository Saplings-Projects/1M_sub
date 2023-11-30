extends Node2D
class_name ClickHandler


# emits when area is clicked
signal on_click
# emits once when the area is hovered
signal on_hover
# emits once when the area is unhovered
signal on_unhover
# emits any time the mouse moves in the area
signal on_mouse_hovering

var _is_interactable : bool = true


func set_interactable(interactable : bool):
	_is_interactable = interactable
	if not _is_interactable:
		on_unhover.emit()


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if not _is_interactable:
		return
		
	if event is InputEventMouseButton and event.pressed:
		on_click.emit()
	if event is InputEventMouseMotion:
		on_mouse_hovering.emit()


func _on_area_2d_mouse_entered():
	if not _is_interactable:
		return

	on_hover.emit()


func _on_area_2d_mouse_exited():
	if not _is_interactable:
		return
		
	on_unhover.emit()
