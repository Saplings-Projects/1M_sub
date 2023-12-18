# Base class for card effects
class_name EffectBase extends Node

@warning_ignore("unused_parameter")
func apply_effect(caster: Entity, target: Entity, value: float) -> void:
    pass

# To be called by child classes through apply_effect. But since there might be multiple effects that need it, it's available in the parent class
func _apply_status(status: StatusBase, caster: Entity, target: Entity) -> void:
    target.get_status_component().add_status(status, caster)