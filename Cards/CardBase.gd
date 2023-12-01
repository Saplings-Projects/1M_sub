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
## This includes functionality for applying damage to both the victim and attacker. Attackers may
## wish to take damage in some contexts.
## For example, consider the card: "Deal 10 damage to all enemies, but take 3 damage"


@export var damage_to_apply_to_victim: float = 0.0
@export var damage_to_apply_to_attacker: float = 0.0
@export var buffs_to_apply_to_victim: Array[BuffBase]
@export var buffs_to_apply_to_attacker: Array[BuffBase]
@export var affect_all_victims: bool = false
@export var affect_all_attackers: bool = false
@export var application_type: Enums.ApplicationType = Enums.ApplicationType.ENEMY_ONLY
@export var card_title: String = "NULL"
@export var card_key_art: ImageTexture = null
@export var card_description: String = "NULL"


func try_play_card(attacker: Entity, victim: Entity) -> bool:
	if attacker.get_party_component().can_play_on_entity(application_type, victim):
		_on_card_play(attacker, victim)
		return true
	return false


func _on_card_play(attacker: Entity, victim: Entity) -> void:
	_deal_damage(attacker, victim)
	_apply_buffs(attacker, victim)
	# TODO add other functionality that lots of cards may share (eg: restore AP, draw cards)


# override in child cards if you want to deal damage in a unique way
func _deal_damage(attacker: Entity, victim: Entity) -> void:
	# damage victim
	if damage_to_apply_to_victim != 0.0:
		_damage_entity(victim, attacker, damage_to_apply_to_victim, affect_all_victims)
	
	#damage attacker
	if damage_to_apply_to_attacker != 0.0:
		_damage_entity(attacker, attacker, damage_to_apply_to_attacker, affect_all_attackers)


func _damage_entity(victim: Entity, attacker: Entity, damage_amount: float, damage_all: bool) -> void:
	var victim_damage_data: DealDamageData = DealDamageData.new()
	victim_damage_data.damage = damage_amount
	victim_damage_data.attacker = attacker
	
	# If damage_all is set, try to damage all the party members set in the party component
	if damage_all:
		var party: Array[Entity] = victim.get_party_component().party
		assert(party.size() > 0, "Entity has an empty party. Make sure you added party members.")
		
		for party_member: Entity in party:
			party_member.get_health_component().deal_damage(victim_damage_data)
	else:
		victim.get_health_component().deal_damage(victim_damage_data)


func _apply_buffs(attacker: Entity, victim: Entity) -> void:
	# apply buffs to attacker
	for buff: BuffBase in buffs_to_apply_to_attacker:
		if affect_all_attackers:
			for party_member: Entity in attacker.get_party_component().party:
				party_member.get_buff_component().add_buff(buff, attacker)
		else:
			attacker.get_buff_component().add_buff(buff, attacker)
	
	# apply buffs to victim
	for buff: BuffBase in buffs_to_apply_to_victim:
		if affect_all_victims:
			for party_member: Entity in victim.get_party_component().party:
				party_member.get_buff_component().add_buff(buff, attacker)
		else:
			victim.get_buff_component().add_buff(buff, attacker)
