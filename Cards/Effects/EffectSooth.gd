class_name EffectSooth extends EffectBase
## Sooth an entity. [br]
##
## This effect will reduce the amount of stress of the target entity. [br]
## Modifier key is SOOTH. [br]


## @Override [br]
## Refer to [EffectBase]
func apply_effect(caster: Entity, target: Entity, value: int) -> void:

	# calculate modified sooth given caster and target stats
	var sooth: int = EntityStats.get_value_modified_by_stats(GlobalEnums.PossibleModifierNames.SOOTH, caster, target, value)
	
	target.get_stress_component().modify_stress(sooth, caster, true)
