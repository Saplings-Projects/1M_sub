class_name EffectData extends Resource
## Wrapper around the effect class to store the data of the effect
##
## This is a convenient way to apply effect while holding all the necessary information in a single class.

## The effect to apply
@export var effect: EffectBase = null
## The entity that cast the effect (depends on the context).
var caster: Entity = null
## The value of the effect, see [EffectBase] for more information.
@export var value: int = 0
## The targeting function to use. This will give the list of all the targets that the effect is cast on, see [TargetingBase] for more information.
@export var targeting_function: TargetingBase = null
@export var animation_data: CastAnimationData = null

func _init(
	_effect: EffectBase = null,
	_caster: Entity = null, 
	_value: int = 0, 
	_targeting_function: TargetingBase = null,
	_animation_data: CastAnimationData = null
	) -> void:
	self.effect = _effect
	self.caster = _caster
	self.value = _value
	self.targeting_function = _targeting_function
	self.animation_data = _animation_data

## Help function to call more easily from the card point of view
func apply_effect_data(_caster: Entity = caster, target: Entity = null) -> void:
	self.effect.apply_effect(_caster, target, self.value)
