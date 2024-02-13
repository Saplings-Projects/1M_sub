class_name TargetAll extends TargetingBase

func _init() -> void:
    cast_type = Enums.CardCastType.INSTA_CAST

    

# @Override
@warning_ignore("unused_parameter")
func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
    var all_list: Array[Entity] = [PlayerManager.player]
    all_list.append_array(EnemyManager.enemy_list)
    return all_list