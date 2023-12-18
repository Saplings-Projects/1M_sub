class_name EffectData extends Node

# Effect data is a wrapper for the Effect class. It contains an effect, a caster, a target and a value (which will be applied by the effect)

var effect: EffectBase = null
var caster: Entity = null
var target: Entity = null
var value: float = 0

func _init(_effect: EffectBase, _caster: Entity, _target: Entity, _value: float) -> void:
    self.effect = _effect
    self.caster = _caster
    self.target = _target
    self.value = _value

func add_effect_data(card: CardBase, _effect: EffectBase, _caster: Entity, _target: Entity, _value: float) -> void:
    card.card_effects_data.append(EffectData.new(_effect, _caster, _target, _value))