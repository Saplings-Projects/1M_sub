extends CastPosition
class_name CastPos_AllTargets
## CastPos_AllTargets creates an animation for each target


@export var offset: Vector2 = Vector2.ZERO


# @Override
func initialize_animation(cast_animation_scene: PackedScene, list_targets: Array[Entity]) -> Array[CastAnimation]:
	var cast_animations: Array[CastAnimation] = []
	
	for target in list_targets:
		var cast_animation: CastAnimation = cast_animation_scene.duplicate().instantiate()
		
		cast_animations.append(cast_animation)
		
		target.add_child(cast_animation)
		cast_animation.position += offset
		
		cast_animation.play_animation([target])
	
	return cast_animations
