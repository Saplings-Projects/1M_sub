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

@export var damage_to_apply_to_target: float = 0.0
@export var damage_to_apply_to_caster: float = 0.0
@export var status_to_apply_to_target: Array[StatusBase]
@export var status_to_apply_to_caster: Array[StatusBase]
@export var affect_all_targets: bool = false
@export var affect_all_casters: bool = false
@export var amount_of_cards_to_draw: int = 0
@export var amount_of_cards_to_discard: int = 0
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

func _apply_all_effects(target: Entity) -> void:
	for effect_data: EffectData in card_effects_data:
		effect_data.apply_effect_data(target)

func _apply_effect(target : Entity, effect: EffectData):
	effect.apply_effect_data(target)

func can_play_card(caster: Entity, target: Entity) -> bool:
	return caster.get_party_component().can_play_on_entity(application_type, target)


func on_card_play(caster: Entity, targets: Array[Entity]) -> void:
	#Split up targeted attacks and all attacks
	var target_effects: Array[EffectData] = []
	var all_effects: Array[EffectData] = []
	
	for effect_data: EffectData in card_effects_data:
		if(effect_data.target_type == Enums.TargetType.SINGLE_TARGET):
			target_effects.push_front(effect_data)
		else :
			all_effects.push_front( effect_data)
	#Apply single target
	for entity : Entity in targets:
		for effect : EffectData in target_effects:
			_apply_effect(entity, effect)
	#Get every unit that is to be affected by card
	var all_target : Array[Entity]
	
	match application_type:
		Enums.ApplicationType.ALL:
			all_target = CardManager.card_container.battler_refrence._enemy_list
			all_target += [PlayerManager.player]
		Enums.ApplicationType.ENEMY_ONLY:
			all_target = CardManager.card_container.battler_refrence._enemy_list
		Enums.ApplicationType.FRIENDLY_ONLY:
			all_target = [PlayerManager.player]
	#apply effect to every target
	for entity : Entity in all_target:
		for effect : EffectData in all_effects:
			_apply_effect(entity, effect)
	
	CardManager.on_card_action_finished.emit(self)


# override in child cards if you want to deal damage in a unique way
func _deal_damage(caster: Entity, target: Entity) -> void:
	# damage target
	if damage_to_apply_to_target != 0.0:
		_damage_entity(caster, target, damage_to_apply_to_target, affect_all_targets)
	
	#damage caster
	if damage_to_apply_to_caster != 0.0:
		_damage_entity(caster, caster, damage_to_apply_to_caster, affect_all_casters)


func _damage_entity(caster: Entity, target: Entity, damage_amount: float, damage_all: bool) -> void:
	var target_damage_data: DealDamageData = DealDamageData.new()
	target_damage_data.damage = damage_amount
	target_damage_data.caster = caster
	
	# If damage_all is set, try to damage all the party members set in the party component
	if damage_all:
		var party: Array[Entity] = target.get_party_component().party
		assert(party.size() > 0, "Entity has an empty party. Make sure you added party members.")
		
		for party_member: Entity in party:
			party_member.get_health_component().deal_damage(target_damage_data)
	else:
		target.get_health_component().deal_damage(target_damage_data)


func _apply_status(caster: Entity, target: Entity) -> void:
	# apply status to caster
	for status: StatusBase in status_to_apply_to_caster:
		if affect_all_casters:
			for party_member: Entity in caster.get_party_component().party:
				party_member.get_status_component().add_status(status, caster)
		else:
			caster.get_status_component().add_status(status, caster)
	
	# apply status to target
	for status: StatusBase in status_to_apply_to_target:
		if affect_all_targets:
			for party_member: Entity in target.get_party_component().party:
				party_member.get_status_component().add_status(status, caster)
		else:
			target.get_status_component().add_status(status, caster)


func _draw_cards() -> void:
	CardManager.card_container.draw_cards(amount_of_cards_to_draw)


func _discard_random_cards() -> void:
	CardManager.card_container.discard_random_card(amount_of_cards_to_discard)
