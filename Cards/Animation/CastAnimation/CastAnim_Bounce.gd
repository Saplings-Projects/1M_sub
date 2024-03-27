extends CastAnimation
class_name CastAnim_Bounce


var _bounce_length: float = 0.0
var _bounce_targets: Array[Entity] = []
var _caster: Entity = null

# Needed because the last bounce will not trigger since the calculation of _bounce_length
# can be inaccurate due to division
const ANIMATION_LENGTH_BUFFER: float = 0.05


# @Override
func init_animation(caster: Entity, targets: Array[Entity]) -> void:
	_bounce_targets = targets.duplicate()
	_bounce_targets.insert(0, caster)
	_caster = caster


#@Override
func play_animation() -> void:
	var animation_length: float = animation.current_animation_length - ANIMATION_LENGTH_BUFFER
	_bounce_length = animation_length / (_bounce_targets.size() - 1)
	
	_start_bouncing()


func _start_bouncing() -> void:
	var current_hit_target: Entity = _bounce_targets[0]
	
	if current_hit_target != _caster:
		on_animation_hit_triggered.emit(current_hit_target)
		_was_animation_hit_triggered = true
	
	# Try to bounce to the next target if there is another. If not, exit
	var current_bounce_target: Entity = null
	if _bounce_targets.size() > 1:
		current_bounce_target = _bounce_targets[1]
	else:
		return
	
	_bounce_targets.remove_at(0)
	
	create_tween()\
	.tween_property(self, EasingConstants.GLOBAL_POSITION_PROPERTY, current_bounce_target.global_position, _bounce_length)
	
	await current_bounce_target.get_tree().create_timer(_bounce_length).timeout
	
	_start_bouncing()
