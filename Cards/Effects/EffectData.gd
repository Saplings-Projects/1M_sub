class_name EffectData extends Node

# Effect data is a wrapper for the Effect class. It contains an effect, a caster, a target and a value (which will be applied by the effect)

var effect: EffectBase = null
var caster: Entity = null
var list_targets: Array[Entity] = []
var value: float = 0

func _init(_effect: EffectBase, _caster: Entity, _list_targets: Array[Entity], _value: float) -> void:
    self.effect = _effect
    self.caster = _caster
    self.list_targets = _list_targets
    self.value = _value

func add_effect_data(card: CardBase, _effect: EffectBase, _caster: Entity, _list_targets: Array[Entity], _value: float) -> void:
    card.card_effects_data.append(EffectData.new(_effect, _caster, _list_targets, _value))

func apply_effect_data() -> void:
    # Help function to call more easily from the card point of view
    for target: Entity in list_targets:
        self.effect.apply_effect(self.caster, target, self.value)