extends Node2D

## * We do this to properly init the battle state
## Before, the testing scene was the main scene so it was properly started by the phase manager
## Now that the main scene is the main menu and we load the testing scene from there, we init to properly init the game state 

func _ready() -> void:
	_play_music()
	SaveManager.execute_save()
	PhaseManager.initialize_game()

func _play_music() -> void:
	var number_of_floors: float = MapManager.get_floors()
	
	# Offset by 1 since it's reading from an array
	var current_player_floor: float = PlayerManager.player_position.y + 1
	
	var percentage_complete: float = (current_player_floor / number_of_floors) * 100
	var music_track: GlobalEnums.MusicTrack
	if percentage_complete <= 33:
		music_track = GlobalEnums.MusicTrack.AREA_ONE
	elif percentage_complete > 33 and percentage_complete <= 66:
		music_track = GlobalEnums.MusicTrack.AREA_TWO
	elif percentage_complete > 66 and percentage_complete <= 99:
		music_track = GlobalEnums.MusicTrack.AREA_THREE
	else:
		music_track = GlobalEnums.MusicTrack.BOSS
	
	AudioManager.start_music(music_track)
