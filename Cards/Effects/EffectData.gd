class_name EffectData extends Resource

# Effect data is a wrapper for the Effect class. It contains an effect, a caster, a target and a value (which will be applied by the effect)

@export var effect: EffectBase = null
var caster: Entity = null
var list_targets: Array[Entity] = []
@export var value: int = 0
@export var target_type : Enums.TargetType = Enums.TargetType.ALL_TARGETS #TODO Target change
# ? still needed given targeting function
# ? or can remove since the targeting function includes the target_type
@export var targeting_function: TargetingBase = null

func _init(	_effect: EffectBase = null,
			_caster: Entity = null, 
			_list_targets: Array[Entity] = [], 
			_value: int = 0, 
			_targeting_function: TargetingBase = null) -> void:
	self.effect = _effect
	self.caster = _caster
	self.list_targets = _list_targets
	self.value = _value
	self.targeting_function = _targeting_function

func apply_effect_data(_caster: Entity = caster, target: Entity = null) -> void:
	# Help function to call more easily from the card point of view
	list_targets = targeting_function.generate_target_list(target)
	for list_targets_member: Entity in list_targets:
		self.effect.apply_effect(_caster, list_targets_member, self.value)
	list_targets = []
