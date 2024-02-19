extends Node
class_name Enums
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


enum CardAnimationTransformType
{
	NONE,
	TARGET_POSITION,
}
