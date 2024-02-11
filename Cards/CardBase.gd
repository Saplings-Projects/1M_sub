extends Resource
class_name CardBase
## Resource that holds data about a card and provides functions that all derived cards could
## use if they want.
##
## The intention with this is to provide functionality that is common to a lot of cards,
## like dealing damage, drawing cards, and restoring resources.
## If you want functionality that's unique to a certain card, then create a new child of this
## and override one of the functions below.
## This resource also has data that is used for displaying the card in the world, like
## description, title, and key art.
## This includes functionality for applying damage to both the target and caster. Casters may
## wish to take damage in some contexts.
## For example, consider the card: "Deal 10 damage to all enemies, but take 3 damage"

@export var application_type: Enums.ApplicationType = Enums.ApplicationType.ENEMY_ONLY
@export var card_title: String = "NULL"
@export var card_key_art: ImageTexture = null
@export var card_description: String = "NULL"

@export var card_effects_data: Array[EffectData] = []

func _ready() -> void:
	card_effects_data = []

# Need a parser of some sort to read a plainform card data and translate it to EffectData
# This will call EffectData.add_effect_data() in a loop for every new effect

@warning_ignore("unused_parameter")
func parse_card_data(card_data: Dictionary) -> void:
	# TODO
	pass


func _apply_all_effects(caster: Entity, targets: Array[Entity], effects: Array[EffectData]) -> void:
	for target : Entity in targets:
		for effect : EffectData in effects:
			effect.apply_effect_data(caster, target)


func can_play_card(caster: Entity, target: Entity) -> bool:
	return caster.get_party_component().can_play_on_entity(application_type, target)


func on_card_play(caster: Entity, targets: Array[Entity]) -> void:
	#Split up targeted attacks and all attacks
	var effects_targeting_single: Array[EffectData] = get_effects_targeting_single()
	var effects_targeting_all: Array[EffectData] = get_effects_target_all()
	
	#Apply single target
	_apply_all_effects(caster, targets, effects_targeting_single)
	#Get every unit that is to be affected by card
	var all_targets : Array[Entity] = CardManager.card_container.battler_refrence.get_all_targets(application_type)
	#TODO this needs to be changed because the targeting functions don't work like that anymore

	#apply effect to every target
	_apply_all_effects(caster, all_targets, effects_targeting_all)
	

	CardManager.on_card_action_finished.emit(self)

func get_effects_targeting_single() -> Array[EffectData]:
	var target_effects: Array[EffectData] = []
	
	for effect_data: EffectData in card_effects_data:
		if(effect_data.target_type == Enums.TargetType.SINGLE_TARGET):
			#TODO Target change
			target_effects.append(effect_data)
			
	return target_effects

func get_effects_target_all() -> Array[EffectData]:
	var all_effects: Array[EffectData] = []
	
	for effect_data: EffectData in card_effects_data:
		if(effect_data.target_type == Enums.TargetType.ALL_TARGETS):
			#TODO Target change
			all_effects.append(effect_data)
			
	return all_effects

