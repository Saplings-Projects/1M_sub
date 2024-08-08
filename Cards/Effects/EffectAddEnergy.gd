class_name EffectAddEnergy extends EffectBase
## Add energy to the player
##
## Refer to [EnergyComponent] for more information.

## @Override [br]
## Refer to [EffectBase]
func apply_effect(_caster: Entity, _target: Entity, value: int) -> void:
	PlayerManager.player.get_energy_component().add_energy(value)
