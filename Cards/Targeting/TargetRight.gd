class_name TargetRight extends TargetingBase

func _init() -> void:
    cast_type = GlobalEnum.CardCastType.TARGET

    
# ! This class assumes that enemies are in the same order on the screen than the order of the enemy list

# @Override
func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
    var enemy_list: Array[Entity] = EnemyManager.enemy_list
    var index_of_current_target: int = enemy_list.find(targeted_entity)
    assert(index_of_current_target != -1, "The targeted enemy is not in the list of enemies")
    var target_list: Array[Entity] = [targeted_entity]
    if index_of_current_target < enemy_list.size() - 1:
        target_list.append(enemy_list[index_of_current_target + 1])
    return target_list
