class_name EffectBase extends Resource
## The parent class of all effects
##
## An effect is the smallest unit of action that can be done in the game. [br]
## It is a simple action that can be applied to an entity.
## For example, dealing damage, healing, drawing cards... [br]
## Some effects don't do anything on their own and need something more (see [EffectApplyStatus] which applies a status). [br]
## Cards have one or more effects that are applied when the card is played.


## Apply the effect to the target entity [br]
## [param caster] The entity that is applying the effect [br]
## [param target] The entity that is the target of the effect [br]
## [param value] A numerical value to quantify the strength of the effect [br]
## The [param caster] and [param target] parameters are used to determine the modification of the [param value] due to the entities' stats (usually modified via Status) [br]
## Refer to [EntityStats] and the related effects to see how this calculation is done. [br]
@warning_ignore("unused_parameter")
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	pass
