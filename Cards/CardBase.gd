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

@export var energy_info: EnergyData = EnergyData.new()

func _ready() -> void:
	card_effects_data = []

# Need a parser of some sort to read a plainform card data and translate it to EffectData
# This will call EffectData.add_effect_data() in a loop for every new effect

@warning_ignore("unused_parameter")
func parse_card_data(card_data: Dictionary) -> void:
	# TODO
	pass


func can_play_card(caster: Entity, target: Entity) -> bool:
	return caster.get_party_component().can_play_on_entity(application_type, target)


func on_card_play(caster: Entity, base_target: Entity) -> void:
	if caster is Player:
		PlayerManager.player.get_energy_component().use_energy(self)	
	
	for effect_data: EffectData in card_effects_data:
		var list_targets: Array[Entity] = effect_data.targeting_function.generate_target_list(base_target)
		for current_target in list_targets:
			effect_data.apply_effect_data(caster, current_target)
	CardManager.on_card_action_finished.emit(self)
