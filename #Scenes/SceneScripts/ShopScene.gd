extends Control

func _ready() -> void:
	AudioManager.start_music(GlobalEnums.MusicTrack.SHOP)
	SaveManager.execute_save()
