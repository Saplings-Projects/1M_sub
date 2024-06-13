extends Control

@export var splash_image: TextureRect
@export var uuuu_sfx: AudioStreamPlayer2D

var tween: Tween

func _ready() -> void:
	tween = create_tween()
	var original_scale: Vector2 = splash_image.scale
	# Animation to slingshot the logo, scale low the image with a spring like animation 
	# then scale it back to original size with an elastic like animation
	# Play Fauna uuuu-ing in-between, then fade splash away and navigate to main menu when done
	tween.tween_property(splash_image, "scale", Vector2(0.30, 0.30), 1.5).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)
	tween.tween_callback(_play_sfx)
	tween.tween_property(splash_image, "scale", original_scale, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(splash_image, "modulate:a", 0, 1)
	tween.tween_callback(_on_tween_finish)
	

func _on_tween_finish() -> void:
	SceneManager.goto_scene("res://#Scenes/MainMenu.tscn")

func _play_sfx() -> void:
	uuuu_sfx.play()
