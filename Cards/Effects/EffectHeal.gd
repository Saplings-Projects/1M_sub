class_name EffectHeal extends EffectBase
## Heals an entity. [br]
##
## This effect will heal the target entity. The healing is calculated based on the value of the effect and the caster stats. [br]
## Modifier key is HEAL. [br]


## @Override [br]
## Refer to [EffectBase]
func apply_effect(caster: Entity, target: Entity, value: int) -> void:

	# calculate modified heal given caster and target stats
	var heal: int = EntityStats.get_value_modified_by_stats(GlobalEnums.PossibleModifierNames.HEAL, caster, target, value)
	
	target.get_health_component().heal(heal, caster) 
