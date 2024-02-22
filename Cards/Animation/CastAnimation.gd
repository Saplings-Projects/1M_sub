extends Node2D
class_name CastAnimation
## Base cast animation that should be on the root of all card animation scenes


signal on_animation_hit_triggered
signal on_animation_cast_complete


@export var animation: AnimationPlayer = null

var _was_animation_hit_triggered: bool = false


func _ready() -> void:
	animation.animation_finished.connect(_finish_casting)


@warning_ignore("unused_parameter")
func play_animation(targets: Array[Entity]) -> void:
	pass


func trigger_cast_hit() -> void:
	if _was_animation_hit_triggered:
		push_error("Tried to trigger multiple hits in CastAnimation " + get_name())
		return
	
	on_animation_hit_triggered.emit()
	_was_animation_hit_triggered = true


func _finish_casting(_anim_name: StringName) -> void:
	# If the animation didn't trigger a hit, then trigger when the animation is complete.
	if not _was_animation_hit_triggered:
		trigger_cast_hit()
	
	on_animation_cast_complete.emit()
	queue_free()
