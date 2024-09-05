extends EffectBase
class_name EffectAddBlock
## gives block to an entity. [br]
##
## This effect gives block to target entity equal to the value given[br]

## @Override [br]
## Refer to [EffectBase]
func apply_effect(_caster: Entity, _target: Entity, value: int) -> void:
	_target.get_health_component().add_block(value, _caster)
