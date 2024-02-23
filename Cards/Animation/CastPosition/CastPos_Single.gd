extends CastPosition
class_name CastPos_CentralPosition
## Creates a single animation at a central position between all targets


## If false, creates the animation at 0,0
@export var use_central_position: bool = true
@export var offset: Vector2 = Vector2.ZERO


# @Override
func initialize_animation(cast_animation_scene: PackedScene, list_targets: Array[Entity]) -> CastAnimation:
	var cast_animation: CastAnimation = cast_animation_scene.instantiate()
	
	assert(list_targets.size() > 0, "Tried to create a CastPos_Single with no targets")
	
	list_targets[0].get_tree().root.add_child(cast_animation)
	
	if use_central_position:
		var target_positions: Array[Vector2] = []
		for target: Entity in list_targets:
			target_positions.append(target.global_position)
		
		cast_animation.global_position = Helpers.get_mean_vector(target_positions)
	
	cast_animation.global_position += offset
	
	cast_animation.play_animation(list_targets)
	
	return cast_animation
