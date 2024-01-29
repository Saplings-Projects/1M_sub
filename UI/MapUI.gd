extends Control

var map_scene: PackedScene = preload("res://#Scenes/CardScrollUI.tscn")
var room_ui: PackedScene = load("res://Map/RoomUI.tscn")
var _padding_offset = 20

func _input(_inputevent: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		queue_free()


func _on_return_button_press():
	queue_free()


func _ready():
	var current_map = MapManager.current_map
	var new_room = room_ui.instantiate()
	var new_room_size = new_room.get_child(0).get_size()
	var color_rect = get_child(0)
	var scroll_container = get_child(1)
	var room_container = scroll_container.get_child(0)
	print(color_rect.get_size())
	var starting_map_node = Vector2(color_rect.get_size().x / 2, color_rect.get_size().y / 2)
	
	#TODO: Find the max rooms 
	var start_position_for_next_room_x = room_container.position.x + room_container.get_size().x / 2 - ((new_room_size.x + _padding_offset) * MapManager.map_width_array.max()) / 2
	var start_position_for_next_room_y = room_container.position.y + room_container.get_size().y - new_room_size.y - _padding_offset
	var position_for_next_room = Vector2(start_position_for_next_room_x, start_position_for_next_room_y)
	for width_array in current_map.rooms:
		position_for_next_room.x = start_position_for_next_room_x
		for room in width_array:
			if (room != null):
				var room_test = room_ui.instantiate()
				room_container.add_child(room_test)
				room_test.set_label(room.get_room_abbreviation())
				room_test.position = position_for_next_room
			position_for_next_room.x += new_room_size.x + _padding_offset
		position_for_next_room.y -= new_room_size.y + _padding_offset
