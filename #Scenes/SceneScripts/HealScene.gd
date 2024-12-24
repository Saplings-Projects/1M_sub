extends Control

func _ready() -> void:
	AudioManager.start_music(GlobalEnums.MusicTrack.HEAL)
	SaveManager.execute_save()
