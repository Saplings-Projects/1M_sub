extends Control
class_name ShopScene

func _ready() -> void:
	SaveManager.execute_save()

func _stock_shop() -> void:
	pass


func _on_button_pressed() -> void:
	PlayerManager.player_room.room_event.on_event_ended()
	pass # Replace with function body.
