extends Node
class_name ClickHandler


# emits when area is clicked
signal on_click
# emits once when the area is hovered
signal on_hover
# emits once when the area is unhovered
signal on_unhover
# emits any time the mouse moves in the area
signal on_mouse_hovering

var _is_interactable: bool = true


func set_interactable(interactable: bool) -> void:
	if not interactable:
		on_unhover.emit()
	_is_interactable = interactable


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	_on_gui_input_event(event)


func _on_gui_input_event(event: InputEvent) -> void:
	if not _is_interactable:
		return
		
	if event is InputEventMouseButton and event.pressed:
		on_click.emit()
	if event is InputEventMouseMotion:
		on_mouse_hovering.emit()


func _on_mouse_entered() -> void:
	if not _is_interactable:
		return

	on_hover.emit()


func _on_mouse_exited() -> void:
	if not _is_interactable:
		return
		
	on_unhover.emit()
