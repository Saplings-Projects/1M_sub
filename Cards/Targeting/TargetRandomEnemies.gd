class_name TargetRandomEnemies extends TargetingBase

@export var number_of_targets: int = 0

func _init():
    cast_type = Enums.CardCastType.INSTA_CAST
    application_type = Enums.ApplicationType.ENEMY_ONLY
    

# @Override
@warning_ignore("unused_parameter")
func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
    var target_list = []
    var enemy_list: Array[Entity] = EnemyManager.enemy_list
    var enemy_list_size: int = enemy_list.size()
    for _i in range(number_of_targets):
        var random_index: int = randi_range(0,enemy_list_size-1)
        target_list.append(enemy_list[random_index])
        # you can target the same enemy multiple times
    return target_list