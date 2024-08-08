extends Sprite2D
class_name block_display

## UI element to display block for an entity[br]

@export var label : Label
@export var healthComponent : HealthComponent

func _ready() -> void:
	healthComponent.on_block_changed.connect(change_display)

## Changes the number on the display, if it's 0 then the shield is hidden[br]
func change_display(new_num : int) -> void:
	
	if(new_num == 0):
		visible = false
	else:
		visible = true
	
	label.text = str(new_num)
