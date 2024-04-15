extends Node
## Simple state machine that manages whatever state the game is in.
##
## The main game phases and PLAYER_ATTACKING and ENEMY_ATTACKING. If you want to know when a phase
## starts/ends, bind to on_phase_changed. You can call set_phase from anywhere, however this should
## be kept to as little calls as we can to reduce confusion with game phase changes.


signal on_game_start
signal on_phase_changed(new_phase: GlobalEnums.Phase, old_phase: GlobalEnums.Phase)
signal on_event_win
signal on_defeat

var current_phase: GlobalEnums.Phase = GlobalEnums.Phase.NONE


func _ready() -> void:
	# initialize_game()
	return
	

func initialize_game() -> void:
	set_phase(GlobalEnums.Phase.GAME_STARTING)
	
	# TODO give all objects some time to initialize. Kinda hacky
	await get_tree().create_timer(.1).timeout
	_start_game()


func _start_game() -> void:
	set_phase(GlobalEnums.Phase.PLAYER_ATTACKING)
	on_game_start.emit()


func set_phase(phase: GlobalEnums.Phase) -> void:
	if (current_phase == phase):
		return
	var old_phase: GlobalEnums.Phase = current_phase
	current_phase = phase
	on_phase_changed.emit(current_phase, old_phase)
