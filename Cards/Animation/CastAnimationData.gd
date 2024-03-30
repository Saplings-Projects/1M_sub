extends Resource
class_name CastAnimationData
## Used by CardBase to store card animation data


@export var cast_animation_scene: PackedScene = null
@export var cast_position: CastPosition = null


func can_use_animation() -> bool:
	return cast_animation_scene != null and\
			cast_position != null and\
			!CardManager.disable_card_animations
