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


@export var damage_to_apply_to_victim : float = 0.0
@export var damage_to_apply_to_attacker : float = 0.0
@export var buffs_to_apply_to_victim : Array[BuffBase]
@export var buffs_to_apply_to_attacker : Array[BuffBase]
@export var application_type : Enums.ApplicationType = Enums.ApplicationType.ENEMY_ONLY
@export var card_title : String = "NULL"
@export var card_key_art : ImageTexture = null
@export var card_description : String = "NULL"


func try_play_card(attacker : Entity, victim : Entity) -> bool:
	if attacker.get_party_component().can_play_on_entity(application_type, victim):
		_on_card_play(attacker, victim)
		return true
	return false


func _on_card_play(attacker : Entity, victim : Entity) -> void:
	_deal_damage(attacker, victim)
	_apply_buffs(attacker, victim)
	# TODO do other functionality that lots of cards may share (eg: restore AP, draw cards)


# override in child cards if you want to deal damage in a unique way
func _deal_damage(attacker : Entity, victim : Entity) -> void:
	var victim_damage_data : DealDamageData = DealDamageData.new()
	victim_damage_data.damage = damage_to_apply_to_victim
	victim_damage_data.attacker = attacker
	victim.get_health_component().deal_damage(victim_damage_data)
	
	var attacker_damage_data : DealDamageData = DealDamageData.new()
	attacker_damage_data.damage = damage_to_apply_to_attacker
	attacker_damage_data.attacker = attacker	
	attacker.get_health_component().deal_damage(attacker_damage_data)


func _apply_buffs(attacker : Entity, victim : Entity) -> void:
	for buff in buffs_to_apply_to_attacker:
		attacker.get_buff_component().add_buff(buff, attacker)
	for buff in buffs_to_apply_to_victim:
		victim.get_buff_component().add_buff(buff, attacker)
