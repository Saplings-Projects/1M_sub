class_name TargetAllAllies extends TargetingBase

func _init() -> void:
    cast_type = Enums.CardCastType.INSTA_CAST

    

# @Override
@warning_ignore("unused_parameter")
func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
    return [PlayerManager.player]
    # ? this might change if we decide that the player can summon minions
    # ? should it be done with get_party_component instead ?
