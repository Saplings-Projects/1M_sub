class_name EffectPoison extends EffectBase

# @Override
func apply_effect(caster: Entity, target:Entity, value: int) -> void:
    var debuff_poison: Debuff_Poison = Debuff_Poison.new() 
    # if not instanciated, the debuff is not seen as a child of StatusBase
    debuff_poison.status_turn_duration = value
    _apply_status(debuff_poison, caster, target)
