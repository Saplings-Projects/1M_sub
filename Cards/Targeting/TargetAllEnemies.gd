class_name  TargetAllEnemies extends TargetingBase

func _init() -> void:
    cast_type = Enums.CardCastType.INSTA_CAST
    application_type = Enums.ApplicationType.ENEMY_ONLY
    

# @Override
@warning_ignore("unused_parameter")
func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
    return EnemyManager.enemy_list
