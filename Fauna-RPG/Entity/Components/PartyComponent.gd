extends EntityComponent
class_name PartyComponent
## Holds data related to the Entity's team and party members.
##
## TODO: in the future we can use this component to get references to other enemies surrounding this
## enemy for stuff like area of effect damage.


@export var team : Enums.Team = Enums.Team.ENEMY


func can_play_on_entity(application_type : Enums.ApplicationType, victim : Entity) -> bool:
	if application_type == Enums.ApplicationType.ALL:
		return true
	
	var victim_team : Enums.Team = victim.get_party_component().team
	var attacker_team : Enums.Team = team
	
	if victim_team == attacker_team:
		if application_type == Enums.ApplicationType.FRIENDLY_ONLY:
			return true
	else:
		if application_type == Enums.ApplicationType.ENEMY_ONLY:
			return true
	
	return false
