class_name TargetingBase extends Resource

var cast_type: Enums.CardCastType
# by default targeting is required but you can have an INSTA_CAST in children class
var application_type: Enums.ApplicationType

func _init():
	cast_type = Enums.CardCastType.TARGET
	application_type = Enums.ApplicationType.ALL


func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
	return [targeted_entity]
