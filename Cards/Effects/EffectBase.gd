# Base class for card effects
class_name EffectBase extends Resource

@warning_ignore("unused_parameter")
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
    pass

# the goal of this function is to provide a base targeting
# here it's not really useful for what is does, but the goal is to return differently
# in children class. For example an AoE where you return the entity and the entities on its side
func build_target_list(target: Entity) -> Array[Entity]:
    return [target]

# To be called by child classes through apply_effect. But since there might be multiple effects that need it, it's available in the parent class
func _apply_status(status: StatusBase, caster: Entity, target: Entity) -> void:
    target.get_status_component().add_status(status, caster)

func calculate_value(name: String, caster: Entity, target: Entity, value: int) -> int:
    var modified_value: int = value
    var caster_stats: EntityStats = caster.get_stats_component().get_stats()
    modified_value = caster_stats.calculate_modified_value(name, modified_value, true) 
    # is_offense = true, caster attacks

    var target_stats: EntityStats = target.get_stats_component().get_stats()
    modified_value = target_stats.calculate_modified_value(name, modified_value, false) 
    # is_offense = false, target defends

    return modified_value
