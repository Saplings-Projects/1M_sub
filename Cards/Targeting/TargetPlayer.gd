class_name TargetPlayer extends TargetingBase

func _init():
	cast_type = Enums.CardCastType.INSTA_CAST
	application_type = Enums.ApplicationType.FRIENDLY_ONLY
	
# @Override
@warning_ignore("unused_parameter")
func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
	return [PlayerManager.player]