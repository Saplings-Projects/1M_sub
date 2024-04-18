extends EntityComponent
class_name PartyComponent
## Holds data related to the Entity's team and party members.
##
## An entity's party also contains the owning entity.

## The team of the entity. [br]
## Note that the team is in a global referential, meaning ENEMY is the enemies of the player._active_card [br]
## FRIENDLY is the player's party, even if technically enemies are friendly to each other.
@export var team: GlobalEnums.Team = GlobalEnums.Team.ENEMY

## The party members of the entity. [br]
## ? Should this be changed to a simpler system with just 2 parties, enemies and players
var party: Array[Entity] = []


## check whether or not something can be played on target given the application type of the thing to check
## For example, a "Heal an ally for 1HP" cannot be played on enemies, but a "Deal 1 damage to an enemy" can.
func can_play_on_entity(application_type: GlobalEnums.ApplicationType, target: Entity) -> bool:
	if application_type == GlobalEnums.ApplicationType.ALL:
		return true
	
	var target_team: GlobalEnums.Team = target.get_party_component().team
	
	if 	target_team == GlobalEnums.Team.FRIENDLY \
		and ( application_type == GlobalEnums.ApplicationType.FRIENDLY_ONLY \
		or application_type == GlobalEnums.ApplicationType.ALL):
			return true
	elif target_team == GlobalEnums.Team.ENEMY \
		and (application_type == GlobalEnums.ApplicationType.ENEMY_ONLY \
		or application_type == GlobalEnums.ApplicationType.ALL):
			return true
	return false 


## Set the party of the entity.
func set_party(in_party: Array[Entity]) -> void:
	party = in_party
	

## Add a party member to the entity's party.
func add_party_member(party_member: Entity) -> void:
	party.append(party_member)
