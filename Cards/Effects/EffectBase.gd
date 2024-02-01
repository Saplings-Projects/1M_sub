# Base class for card effects
class_name EffectBase extends Resource

@warning_ignore("unused_parameter")
func apply_effect(caster: Entity, target: Entity, value: int) -> void:
	pass

# the goal of this function is to provide a base targeting
# here it's not really useful for what is does, but the goal is to return differently
# in children class. For example an AoE where you return the entity and the entities on its side
#TODO change this
func build_target_list(target: Entity) -> Array[Entity]:
	return [target]
