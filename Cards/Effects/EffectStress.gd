class_name EffectStress extends EffectBase
## Stress an enemy [br]
##
## This effect will stress an enemy, increasing its stress level by a certain amount. [br]
## Modifier key is STRESS [br]

## @Override
## Refer to [EffectBase]
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	var stress_increase: int = EntityStats.get_value_modified_by_stats(GlobalEnums.PossibleModifierNames.STRESS, caster, target, value)
	
	target.get_stress_component().modify_stress(stress_increase, caster)
