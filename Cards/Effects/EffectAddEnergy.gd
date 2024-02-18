class_name EffectAddEnergy extends EffectBase

# @overide
func apply_effect(_caster: Entity, _target: Entity, value: int) -> void:
    PlayerManager.player.get_energy_component().add_energy(value)
