extends EntityComponent
class_name BehaviorComponent
## Controls the way enemies behave during a fight.
##
## TODO: right now this just holds a single attack. In the future, we can have this component control the AI decision making for the enemy.
## 


## The attack that the enemy will do
@export var attack: CardBase = null
@export var overstress_attack: CardBase = null


## Setup the attack of the enemy [br]
## This is a basic attack that deals 1 damage to the target [br]
## @experimental
## This will change as enemies will need to have more than a single type of move possible (and even different movement depending on the enemy)
func _ready() -> void:
	attack = CardBase.new()
	var basic_effect_data: EffectData = EffectData.new( EffectDamage.new(),
														null,
														1,
														TargetingBase.new())
	attack.card_effects_data.append(basic_effect_data)
	attack.application_type = GlobalEnums.ApplicationType.FRIENDLY_ONLY
	
	overstress_attack = StressComponent.on_overstress()
	
	
func get_attack(has_hit_overstress: bool) -> CardBase:
	if has_hit_overstress:
		return overstress_attack
	else:
		return attack
