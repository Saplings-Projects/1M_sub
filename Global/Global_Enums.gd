extends Node
class_name GlobalEnum
## Global enums list


enum Phase
{
	NONE,
	GAME_STARTING,
	PLAYER_ATTACKING,
	PLAYER_FINISHING,
	ENEMY_ATTACKING,
	SCENE_END,
}

enum Team
{
	ENEMY,
	FRIENDLY,
}

enum ApplicationType
{
	FRIENDLY_ONLY, 
	ENEMY_ONLY,
	ALL,
}

enum CardCastType
{
	TARGET,
	INSTA_CAST,
}

enum CardMovementState
{
	NONE,
	MOVING_TO_HAND,
	IN_HAND,
	DISCARDING,
	HOVERED,
	QUEUED,
}

enum CombatResult
{
	VICTORY,
	DEFEAT
}

enum LightLevel
{
	UNLIT,
	DIMLY_LIT,
	LIT,
	BRIGHTLY_LIT
}

enum ENTITY_STAT_DICT_TYPE {
	OFFENSE,
	DEFENSE
}

# used to select the offense or defense dictionary for the stats of an entity
# ! don't forget to update _ENTITY_STAT_DICT_SELECTOR in EntityStats.gd if you modify this

enum POSSIBLE_MODIFIER_NAMES {
	DAMAGE,
	POISON,
	DRAW,
	CARD_REWARD_NUMBER
}


