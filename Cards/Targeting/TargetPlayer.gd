class_name TargetPlayer extends TargetingBase

func _init() -> void:
	cast_type = GlobalEnum.CardCastType.INSTA_CAST

	
# @Override
@warning_ignore("unused_parameter")
func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
	return [PlayerManager.player]