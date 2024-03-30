extends CastPosition
class_name CastPos_Caster
## CastPos_Caster creates a single animation at the caster's location


@export var offset: Vector2 = Vector2.ZERO


# @Override
func initialize_animation(cast_animation_scene: PackedScene, caster: Entity, list_targets: Array[Entity]) -> Array[CastAnimation]:
	var cast_animation: CastAnimation = cast_animation_scene.instantiate()
	
	if list_targets.size() <= 0:
		push_error("Tried to create a CastPos_Caster with no targets")
	
	caster.add_child(cast_animation)
	cast_animation.position += offset
	
	cast_animation.init_animation(caster, list_targets)
	
	return [cast_animation]
