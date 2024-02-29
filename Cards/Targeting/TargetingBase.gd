class_name TargetingBase extends Resource

var cast_type: GlobalEnum.CardCastType
# by default targeting is required but you can have an INSTA_CAST in children class


func _init() -> void:
	cast_type = GlobalEnum.CardCastType.TARGET


func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
	return [targeted_entity]
