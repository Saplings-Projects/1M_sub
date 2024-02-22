class_name EffectData extends Resource

# Effect data is a wrapper for the Effect class. It contains an effect, a caster, a target and a value (which will be applied by the effect)

@export var effect: EffectBase = null
var caster: Entity = null
@export var value: int = 0
@export var targeting_function: TargetingBase = null
@export var cast_animation: CastAnimationBase = null

func _init(
	_effect: EffectBase = null,
	_caster: Entity = null, 
	_value: int = 0, 
	_targeting_function: TargetingBase = null,
	_cast_animation: CastAnimationBase = null
	) -> void:
	self.effect = _effect
	self.caster = _caster
	self.value = _value
	self.targeting_function = _targeting_function
	self.cast_animation = _cast_animation

func apply_effect_data(_caster: Entity = caster, target: Entity = null) -> void:
	# Help function to call more easily from the card point of view
	self.effect.apply_effect(_caster, target, self.value)
