class_name EffectApplyStatus extends EffectBase
## Apply a status to the target entity
##
## This class is useful to not have one effect per Status to apply (which was the case before). [br]
## Refer to [StatusBase] and [StatusComponent] for more information about statuses.

## The status to apply
@export var status_to_apply: StatusBase

## @Override [br]
## Refer to [EffectBase]
@warning_ignore("unused_parameter")
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	target.get_status_component().add_status(status_to_apply, caster)
