extends Node
## Simple state machine that manages whatever state the game is in.
##
## The main game phases and PLAYER_ATTACKING and ENEMY_ATTACKING. If you want to know when a phase
## starts/ends, bind to on_phase_changed. You can call set_phase from anywhere, however this should
## be kept to as little calls as we can to reduce confusion with game phase changes.


signal on_game_start
signal on_phase_changed(new_phase: Enums.Phase, old_phase: Enums.Phase)
signal on_combat_end(result: Enums.CombatResult)

var current_phase: Enums.Phase = Enums.Phase.NONE


func _ready() -> void:
	initialize_game()
	

func initialize_game():
	set_phase(Enums.Phase.GAME_STARTING)
	
	# TODO give all objects some time to initialize. Kinda hacky
	await get_tree().create_timer(.1).timeout
	_start_game()


func _start_game() -> void:
	set_phase(Enums.Phase.PLAYER_ATTACKING)
	on_game_start.emit()


func set_phase(phase: Enums.Phase) -> void:
	if (current_phase == phase):
		return
	var old_phase: Enums.Phase = current_phase
	current_phase = phase
	on_phase_changed.emit(current_phase, old_phase)
