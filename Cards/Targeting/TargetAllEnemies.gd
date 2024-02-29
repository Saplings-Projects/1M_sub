class_name  TargetAllEnemies extends TargetingBase

func _init() -> void:
    cast_type = GlobalEnums.CardCastType.INSTA_CAST

    

# @Override
@warning_ignore("unused_parameter")
func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
    return EnemyManager.enemy_list
