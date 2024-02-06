extends Control

var map_scene: PackedScene = preload("res://#Scenes/CardScrollUI.tscn")
var room_ui: PackedScene = load("res://Map/RoomUI.tscn")
var _padding_offset = 20
var _MINIMUM_ROOM_WIDTH = 510
var _MINIMUM_ROOM_HEIGHT = 490

@export var color_rect: ColorRect
@export var scroll_container: SmoothScrollContainer
@export var room_container: ColorRect
@export var room_addition_node: Control

func _input(_inputevent: InputEvent) -> void:
	if (_inputevent.is_action_pressed("cancel_action")):
		queue_free()


func _on_return_button_press():
	queue_free()


func _ready():
	var current_map: MapBase = MapManager.current_map
	
	# Create New Room Object to append to the room container
	var new_room: Control = room_ui.instantiate()
	var new_room_texture_rect: TextureRect = Helpers.get_first_child_node_of_type(new_room, TextureRect)
	var new_room_size: Vector2 = new_room_texture_rect.get_size()
	
	# Get the width of the floor that has the most rooms, by getting the size of what a room is w/ some offset
	var room_container_width: float = ((new_room_size.x + _padding_offset) * MapManager.map_width_array.max()) + _padding_offset
	
	# Check if the room_container_width doesn't meet a certain threshold. If it doesn't set it to a new width, 
	# but save whatever the current width was for positioning later
	var new_room_container_width: float = room_container_width
	if (room_container_width < _MINIMUM_ROOM_WIDTH):
		new_room_container_width = _MINIMUM_ROOM_WIDTH
	
	# Calculate the height of the container where the rooms will reside in. This will be dynamic based on the map array that we have.
	# The array we have in MapManager, each element will increase the height of the map display, 
	# multiply by the size of a room w/ some offset to dynamically set the size of the container of which we will be scrolling.
	var room_container_height: float = MapManager.map_width_array.size() * (new_room_size.y + _padding_offset)
	
	# Check if the room_container_height doesn't meet a certain threshold. If it doesn't meet the threshold theb set it to a new height,
	# but save whatever the current height was for positioning later
	var new_room_container_height: float = room_container_height
	if (room_container_height < _MINIMUM_ROOM_HEIGHT):
		new_room_container_height = _MINIMUM_ROOM_HEIGHT
	
	# Set the custom minimum size of the room container to allow scrolling
	room_container.set_custom_minimum_size(Vector2(new_room_container_width, new_room_container_height))
	
	# Set the size of the scroll container to be dynamic to the max numbers of rooms of a floor
	scroll_container.set_size(Vector2(new_room_container_width, scroll_container.get_size().y))
	
	# We're dynamically sizing the width of the map, as such we need to position it to center it on the screen.
	# X position is calculated by getting half the width of the game screen, then subtracting that from 
	# half the width of the scroll_container 
	var scroll_container_position_x: float = color_rect.get_size().x / 2 - scroll_container.get_size().x / 2
	scroll_container.set_position(Vector2(scroll_container_position_x, scroll_container.position.y))
	
	var scroll_container_bottom_y_position: float = scroll_container.position.y + scroll_container.get_size().y
	
	# Starting positions for the next room to be generated
	# X = the Halfway position of room container - half the size of the longest floor to account for centering all of the rooms. 
	#	  Add a little padding to push it away from the right edge.
	# Y = Height of the Room Container that was calculated in new_room_container_height - (Screen Height - scroll container's bottom y position)
	var start_position_for_next_room_x: float = room_container.position.x + _padding_offset
	var start_position_for_next_room_y: float = room_container.get_custom_minimum_size().y - (color_rect.get_size().y - scroll_container_bottom_y_position)
	var position_for_next_room: Vector2 = Vector2(start_position_for_next_room_x, start_position_for_next_room_y)
	
	for floor: Array[RoomBase] in current_map.rooms:
		# When we're done populating a floor and we go to the next index, reset the X start position
		position_for_next_room.x = start_position_for_next_room_x
		for room: RoomBase in floor:
			if (room != null):
				var room_display: Control = room_ui.instantiate()
				room_addition_node.add_child(room_display)
				room_display.set_label(room.get_room_abbreviation())
				room_display.position = position_for_next_room
			# When we go through the array of a floor to put a room down, 
			# increase the X position to the new potential area the room will be displayed on.
			position_for_next_room.x += new_room_size.x + _padding_offset
		# When we finish the array for a floor we need to go to the next floor up,
		# so increase the Y position to the new area the room will be displayed on.
		position_for_next_room.y -= new_room_size.y + _padding_offset
	
	# Calculate the position of where we should put the rooms. 
	# This is to account for in case the size of the rooms is smaller than the container we put it in
	var new_room_position_x = room_container.get_custom_minimum_size().x / 2 - room_container_width / 2
	
	# If the room_container height is less than the minimum room height 
	# then calculate the position for it to be centered in the middle of the map
	var new_room_position_y = room_container.position.y
	if (room_container_height < _MINIMUM_ROOM_HEIGHT):
		new_room_position_y = room_container.position.y - room_container.get_custom_minimum_size().y / 2 + room_container_height / 2
	room_addition_node.set_position(Vector2(new_room_position_x, new_room_position_y))
