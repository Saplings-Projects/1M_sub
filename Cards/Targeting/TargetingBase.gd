class_name TargetingBase extends Resource

@export var cast_type: Enums.CardCastType = Enums.CardCastType.TARGET
# by default targeting is required but you can have an INSTA_CAST in children class
@export var application_type: Enums.ApplicationType = Enums.ApplicationType.ALL


func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
    return [targeted_entity]
