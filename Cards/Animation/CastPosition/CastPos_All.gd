extends CastPosition
class_name CastPos_All
## CastPos_All creates an animation for each target


@export var offset: Vector2 = Vector2.ZERO


# @Override
func initialize_animation(cast_animation_scene: PackedScene, list_targets: Array[Entity]) -> void:
	var await_cast_animation: CastAnimation = null
	
	for target in list_targets:
		var cast_animation: CastAnimation = cast_animation_scene.instantiate()
		
		if await_cast_animation == null:
			await_cast_animation = cast_animation
		
		target.add_child(cast_animation)
		cast_animation.position += offset
	
	await_cast_animation.on_animation_hit_triggered.connect(func() -> void: on_animation_hit_triggered.emit())
