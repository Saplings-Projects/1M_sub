class_name TargetEverything extends TargetingBase

func _init() -> void:
	cast_type = Enums.CardCastType.INSTA_CAST

#@Override
@warning_ignore("unused_parameter")
func generate_target_list(targeted_entity:Entity) -> Array[Entity]:
	var targets: Array[Entity] = EnemyManager.enemy_list.duplicate()
	targets.append(PlayerManager.player)
	return targets
