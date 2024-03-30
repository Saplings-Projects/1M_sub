class_name TargetingBase extends Resource
## The base class for all types of targeting
##
## This class is used to define what type of targeting the card has. [br]
## When defining an effect data in [EffectData], you define the targeting function of the effect. [br]
## This allows to have the same effect but with multiple possible choice of targets. [br]
## For example, the damage effect can target a single entity, or it could target all the enemies, or all the entities, etc. [br]

## The type of targeting the card has, see [enum GlobalEnums.CardCastType] [br]
## This is set in the _init function
var cast_type: GlobalEnums.CardCastType

## Set the cast type of the card (done this way so that the children class can override it via their own _init function) [br]
## By default targeting is required but you can have an INSTA_CAST ([enum GlobalEnums.CardCastType]) in children class
func _init() -> void:
	cast_type = GlobalEnums.CardCastType.TARGET


## Generate the list of entities that are targeted by the effect [br]
## The default implementation of the targeting is to return the targeted entity, but there can be a lot more types of possible targeting. [br]
## Other types of targeting are defined by children class that override the functions of this class [br]
func generate_target_list(targeted_entity: Entity) -> Array[Entity]:
	return [targeted_entity]
