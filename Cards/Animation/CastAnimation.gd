extends Node2D
class_name CastAnimation
## Base cast animation that should be on the root of all card animation scenes


signal on_animation_hit_triggered(target: Entity)
signal on_animation_cast_complete


@export var animation: AnimationPlayer = null
@export var animation_name: String = ""

var _was_animation_hit_triggered: bool = false
var _current_targets: Array[Entity] = []

func _ready() -> void:
	animation.animation_finished.connect(_finish_casting.unbind(1))


func init_animation(_caster: Entity, targets: Array[Entity]) -> void:
	_current_targets = targets.duplicate()


# At this point it is safe to call on_animation_hit_triggered
# Override in children
func play_animation() -> void:
	pass


# Base functionality triggers the hit on all targets
func trigger_cast_hit() -> void:
	if _was_animation_hit_triggered:
		push_error("Tried to trigger multiple hits in CastAnimation " + get_name())
		return
	
	for target in _current_targets:
		on_animation_hit_triggered.emit(target)
	
	_was_animation_hit_triggered = true


func _finish_casting() -> void:
	# If the animation didn't trigger a hit, then trigger when the animation is complete.
	if not _was_animation_hit_triggered:
		trigger_cast_hit()
	
	on_animation_cast_complete.emit()
	queue_free()

