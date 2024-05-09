class_name EffectDamage extends EffectBase
## Deal damage to an entity. [br]
##
## This effect will deal damage to the target entity. The damage is calculated based on the value of the effect, the caster and target stats. [br]
## Modifier key is DAMAGE. [br]

## @Override [br]
## Refer to [EffectBase]
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	# calculate modified damage given caster and target stats
	var damage: float = EntityStats.get_value_modified_by_stats(GlobalEnums.PossibleModifierNames.DAMAGE, caster, target, value)
	
	target.get_health_component().modify_health(damage, caster)

