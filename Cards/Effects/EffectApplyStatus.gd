class_name EffectApplyStatus extends EffectBase

@export var status_to_apply: StatusBase

# @Override
@warning_ignore("unused_parameter")
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	target.get_status_component().add_status(status_to_apply, caster)
