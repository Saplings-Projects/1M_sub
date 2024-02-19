extends Node2D
class_name CastAnimation


signal on_animation_cast_complete


@export var animation: AnimationPlayer = null
@export var transform_type: Enums.CardAnimationTransformType = Enums.CardAnimationTransformType.TARGET_POSITION
@export var position_offset: Vector2
@export var cast_on_complete: bool = false


func play_animation(target: Entity) -> void:
	match transform_type:
		Enums.CardAnimationTransformType.TARGET_POSITION:
			global_position = target.global_position
	
	global_position += position_offset
	
	animation.animation_finished.connect(_finish_casting)


func trigger_finish_cast() -> void:
	on_animation_cast_complete.emit()


func _finish_casting(_anim_name: StringName) -> void:
	if cast_on_complete:
		trigger_finish_cast()
	
	queue_free()
