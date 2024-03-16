extends EntityComponent
class_name BehaviorComponent
## Enemy's behavior.
##
## TODO: right now this just holds a single attack. In the future, we can have this component
## control the AI decision making for the enemy.


@export var attack: CardBase = null

func _ready() -> void:
	attack = CardBase.new()
	var basic_effect_data: EffectData = EffectData.new( EffectDamage.new(),
														null,
														1,
														TargetingBase.new())
	attack.card_effects_data.append(basic_effect_data)
	attack.application_type = GlobalEnums.ApplicationType.FRIENDLY_ONLY
	

