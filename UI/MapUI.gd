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
	
	# Create New Room Object to append to the room container
	var new_room = room_ui.instantiate()
	var new_room_size = new_room.get_child(0).get_size()
	
	# Get the objets of the Map UI Scene
	var color_rect = get_child(0)
	var scroll_container = get_child(1)
	var room_container = scroll_container.get_child(0)
	
	# Calculate the height of the container where the rooms will reside in. This will be dynamic based on the map array that we have.
	# The array we have in MapManager, each element will increase the height of the map display, 
	# multiply by the size of a room w/ some offset to dynamically set the size of the container of which we will be scrolling.
	var room_container_height = MapManager.map_width_array.size() * (new_room_size.y + _padding_offset)
	room_container.set_custom_minimum_size(Vector2(room_container.get_custom_minimum_size().x, room_container_height))
	
	# Get the x coordinate of the halfway point of the room container
	var room_container_halfway_position_x = room_container.position.x + room_container.get_size().x / 2
	
	# Get the width of the floor that has the most rooms, by getting the size of what a room is w/ some offset, then 
	var longest_floor_size_width = (new_room_size.x + _padding_offset) * MapManager.map_width_array.max()
	
	var scroll_container_bottom_y_position = scroll_container.position.y + scroll_container.get_size().y
	
	# Starting positions for the next room to be generated
	# X = the Halfway position of room container - half the size of the longest floor to account for centering the all of the rooms. 
	#	  Add a little padding to push it away from the right edge.
	# Y = Height of the Room Container that was calculated in room_container_height - (Screen Height - scroll container's bottom y position)
	var start_position_for_next_room_x = room_container_halfway_position_x - longest_floor_size_width / 2 + _padding_offset
	var start_position_for_next_room_y = room_container.get_custom_minimum_size().y - (color_rect.get_size().y - scroll_container_bottom_y_position)
	var position_for_next_room = Vector2(start_position_for_next_room_x, start_position_for_next_room_y)
	
	for width_array in current_map.rooms:
		# When we're done populating a floor and we go to the next index, reset the X start position
		position_for_next_room.x = start_position_for_next_room_x
		for room in width_array:
			if (room != null):
				var room_display = room_ui.instantiate()
				room_container.add_child(room_display)
				room_display.set_label(room.get_room_abbreviation())
				room_display.position = position_for_next_room
			# When we go through the array of a floor to put a room down, 
			# increase the X position to the new potential area the room will be displayed on.
			position_for_next_room.x += new_room_size.x + _padding_offset
		# When we finish the array for a floor we need to go to the next floor up,
		# so increase the Y position to the new area the room will be displayed on.
		position_for_next_room.y -= new_room_size.y + _padding_offset
