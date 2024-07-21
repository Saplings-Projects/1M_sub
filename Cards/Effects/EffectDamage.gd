class_name EffectDamage extends EffectBase
## Deal damage to an entity. [br]
##
## This effect will deal damage to the target entity. The damage is calculated based on the value of the effect, the caster and target stats. [br]
## Modifier key is DAMAGE. [br]

## @Override [br]
## Refer to [EffectBase]
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	# calculate modified damage given caster and target stats
	var damage: int = EntityStats.get_value_modified_by_stats(GlobalEnums.PossibleModifierNames.DAMAGE, caster, target, value)
	
	target.get_health_component().take_damage_block_and_health(damage, caster)

