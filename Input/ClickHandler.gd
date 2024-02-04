extends Node
class_name ClickHandler


# emits when area is left clicked
signal on_click
# emits when area is right clicked
signal on_right_click
# emits once when the area is hovered
signal on_hover
# emits once when the area is unhovered
signal on_unhover
# emits any time the mouse moves in the area
signal on_mouse_hovering

# If greater than 0, then on_mouse_hovering will not trigger for the set time after an unhover event
# NOTE: this is needed because InputEventMouseMotion will sometimes fire after mouse_exited events
@export var time_to_lock_hover: float = 0.0

var _is_interactable: bool = true
var _lock_hover_timer: Timer = null
var _hover_enabled = true


func _ready() -> void:
	if time_to_lock_hover > 0.0:
		_create_lock_hover_timer()


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
		if event.button_index == MOUSE_BUTTON_LEFT:
			on_click.emit()
		else:
			on_right_click.emit()
	if event is InputEventMouseMotion:
		if _hover_enabled:
			on_mouse_hovering.emit()


func _on_mouse_entered() -> void:
	if not _is_interactable:
		return

	on_hover.emit()


func _on_mouse_exited() -> void:
	if not _is_interactable:
		return
	
	_set_lock_hover_timer()
	
	on_unhover.emit()


func _create_lock_hover_timer() -> void:
	_lock_hover_timer = Timer.new()
	add_child(_lock_hover_timer)
	
	# When timer expires, enable hovering
	_lock_hover_timer.timeout.connect(func(): _hover_enabled = true)


func _set_lock_hover_timer() -> void:
	if _lock_hover_timer == null:
		return
	
	# Disable hovering, set timer. When timer expires, hovering will re-enable.
	_hover_enabled = false
	_lock_hover_timer.stop()
	_lock_hover_timer.start(time_to_lock_hover)
