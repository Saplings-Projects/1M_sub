extends Node
class_name GlobalEnums
## Global enums list

## Where are we in the fight
enum Phase
{
	NONE, ## Hello Youston, we are nowhere
	GAME_STARTING, ## The game is starting
	PLAYER_ATTACKING, ## The player is attacking
	PLAYER_FINISHING, ## The player finished its turn (card discard and other stuff starts here)
	ENEMY_ATTACKING, ## Enemy turn
	SCENE_END, ## The current scene ended
}

## In which team is an entity
enum Team
{
	ENEMY, ## This refers to the enemies (of the player)
	FRIENDLY, ## The allies of the player. Even though enemies are friendly between themselves, for the point of view of an enemy, another enemy is still an enemy
}

## Who can be affected by an action
enum ApplicationType
{
	FRIENDLY_ONLY, 
	ENEMY_ONLY,
	ALL,
}

## How the card can be cast
enum CardCastType
{
	TARGET, ## You need to select a target to play this card
	INSTA_CAST, ## You can just play the card and it will know the targets. For example, "deal 3 damage to all enemies" is insta cast
}

## Gives the position of the card on the screen
enum CardMovementState
{
	NONE,
	MOVING_TO_HAND, ## When coming from a deck
	IN_HAND, ## in the player hand, no particular state
	DISCARDING, ## Going from the play area to the discard pile
	HOVERED, ## The mouse of the player is on the card
	QUEUED, ## The card is queued to be played (this happens between the moment the player clicks on the card and the moment he selects a target if needed)
	PLAYING, ## The effects of the card are being played
}


## The level of light on the map
enum LightLevel
{
	UNLIT, ## No light at all
	DIMLY_LIT, ## No torch in range and the player is next to the room
	LIT, ## One torch in range of the room
	BRIGHTLY_LIT ## At least two torches in range of the room
}

## The two types of stats that an entity can have [br]
## The general way to calculate a value modified by stats is base + offense of caster - defense of target
enum EntityStatDictType {
	OFFENSE, ## used to calculate modifiers to a value by the caster
	DEFENSE ## Used the calculate modifiers to a value by the target
}


## The modifiers that can be applied to a value [br]
## This is equivalent to a tag [br]
## Each StatDictType (offense and defense) has all those possible modifiers [br]
## A value of 1 on the DAMAGE of OFFENSE means you deal one more damage [br]
## A value of 1 on the DAMAGE of DEFENSE means you take one less damage [br]
enum PossibleModifierNames {
	DAMAGE,
	HEAL,
	POISON,
	DRAW,
	CARD_REWARD_NUMBER
}
# ! don't forget to update _ENTITY_STAT_DICT_SELECTOR in EntityStats.gd, the test_possible_modifier_size(especifically expected_size)
# in test_stats.gd if you modify this 

## All the possible types of events [br]
## @experimental
##! [method EventRandom.choose_other_event] should be updated if you add a new event  
enum EventType {
	Random, # ! Random should always be the first element (see EventRandom)
	Heal,
	Mob,
	Shop,
	Dialogue,
}
