extends Node
## Simple state machine that manages whatever state the game is in.
##
## The main game phases and PLAYER_ATTACKING and ENEMY_ATTACKING. If you want to know when a phase
## starts/ends, bind to on_phase_changed. You can call set_phase from anywhere, however this should
## be kept to as little calls as we can to reduce confusion with game phase changes.


signal on_game_start
signal on_combat_phase_changed(new_phase: GlobalEnums.CombatPhase, old_phase: GlobalEnums.CombatPhase)
signal on_global_phase_changed(new_phase: GlobalEnums.GlobalPhase, old_phase: GlobalEnums.GlobalPhase)
## When a player wins the event
signal on_event_win
## When the player is dead (reduced to 0 health)
signal on_defeat

var current_combat_phase: GlobalEnums.CombatPhase = GlobalEnums.CombatPhase.PLAYER_ATTACKING
var current_combat_phase_index: int = 0
var current_global_phase: GlobalEnums.GlobalPhase = GlobalEnums.GlobalPhase.NONE

func _ready() -> void:
	# initialize_game()
	return
	

## Init phase
func initialize_game() -> void:
	set_global_phase(GlobalEnums.GlobalPhase.GAME_STARTING)
	
	# TODO give all objects some time to initialize. Kinda hacky
	await get_tree().create_timer(.1).timeout
	_start_game()


## Start the game
func _start_game() -> void:
	_set_combat_phase(GlobalEnums.CombatPhase.PLAYER_ATTACKING)
	on_game_start.emit()


## Change phases in the game (mainly used in combat for now)
func _set_combat_phase(phase: GlobalEnums.CombatPhase) -> void:
	# allow old phase being same as new phase
	# this is if you finish a fight on player turn, you start the next also on player turn
		
	var old_phase: GlobalEnums.CombatPhase = current_combat_phase
	
	current_combat_phase = phase
	on_combat_phase_changed.emit(current_combat_phase, old_phase)

## Call to setup combat phase [br]
## Note: This might be used later to also properly remove block from previous fights
func start_combat() -> void:
	current_combat_phase_index = 0
	_set_combat_phase(GlobalEnums.CombatPhase.values()[0])
	
## Go to the next phase of the combat
func advance_to_next_combat_phase() -> void:
	var combat_phase: Array = GlobalEnums.CombatPhase.values()
	# advance the index by 1, going back to 0 if the index is bigger than the total number of possible phase
	current_combat_phase_index = (current_combat_phase_index + 1) % (combat_phase.size())
	_set_combat_phase(GlobalEnums.CombatPhase.values()[current_combat_phase_index])
	
## Used to set global game phase
func set_global_phase(phase: GlobalEnums.GlobalPhase) -> void:
	if (current_global_phase == phase):
		return
	var old_phase: GlobalEnums.GlobalPhase = current_global_phase
	current_global_phase = phase
	on_global_phase_changed.emit(current_global_phase, old_phase)
