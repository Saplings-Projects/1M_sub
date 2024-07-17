extends Sprite2D

@export var label : Label
@export var healthComponent : HealthComponent

func _ready() -> void:
	healthComponent.on_block_changed.connect(change_display)
	pass

func change_display(new_num : int) -> void:
	label.text = str(new_num)
	pass
