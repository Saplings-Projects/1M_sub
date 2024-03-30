extends CastPosition
class_name CastPos_AllTargets
## CastPos_AllTargets creates an animation for each target


@export var offset: Vector2 = Vector2.ZERO


# @Override
func initialize_animation(cast_animation_scene: PackedScene, caster: Entity, list_targets: Array[Entity]) -> Array[CastAnimation]:
	var cast_animations: Array[CastAnimation] = []
	
	if list_targets.size() <= 0:
		push_error("Tried to create a CastPos_Caster with no targets")
	
	for target in list_targets:
		var cast_animation: CastAnimation = cast_animation_scene.duplicate().instantiate()
		
		cast_animations.append(cast_animation)
		
		target.add_child(cast_animation)
		cast_animation.position += offset
		
		cast_animation.init_animation(caster, [target])
	
	return cast_animations
