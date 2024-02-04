extends Control

var map_scene: PackedScene = preload("res://#Scenes/CardScrollUI.tscn")
var room_ui: PackedScene = load("res://Map/RoomUI.tscn")
var _padding_offset = 20

func _input(_inputevent: InputEvent) -> void:
	if (_inputevent is InputEventKey and _inputevent.pressed and _inputevent.keycode == KEY_ESCAPE):
		queue_free()


func _on_return_button_press():
	queue_free()


var _ROOM_TEXTURE_INDEX = 0
var _COLOR_RECT_INDEX = 0
var _SCROLL_CONTAINER_INDEX = 1
var _ROOM_CONTAINER_INDEX = 0

func _ready():
	var current_map: MapBase = MapManager.current_map
	
	# Create New Room Object to append to the room container
	var new_room: Control = room_ui.instantiate()
	var new_room_size: Vector2 = new_room.get_child(_ROOM_TEXTURE_INDEX).get_size()
	
	# Get the objets of the Map UI Scene
	var color_rect: ColorRect = get_child(_COLOR_RECT_INDEX)
	var scroll_container: SmoothScrollContainer = get_child(_SCROLL_CONTAINER_INDEX)
	var vertical_scroll_bar: VScrollBar = scroll_container.get_v_scroll_bar()
	var room_container: ColorRect = scroll_container.get_child(_ROOM_CONTAINER_INDEX)
	
	# Get the width of the floor that has the most rooms, by getting the size of what a room is w/ some offset, then 
	var room_container_width: float = ((new_room_size.x + _padding_offset) * MapManager.map_width_array.max()) + _padding_offset
	
	# Calculate the height of the container where the rooms will reside in. This will be dynamic based on the map array that we have.
	# The array we have in MapManager, each element will increase the height of the map display, 
	# multiply by the size of a room w/ some offset to dynamically set the size of the container of which we will be scrolling.
	var room_container_height: float = MapManager.map_width_array.size() * (new_room_size.y + _padding_offset)
	room_container.set_custom_minimum_size(Vector2(room_container_width, room_container_height))
	scroll_container.set_size(Vector2(room_container_width, scroll_container.get_size().y))
	
	var scroll_container_position_x = color_rect.get_size().x / 2 - scroll_container.get_size().x / 2
	scroll_container.set_position(Vector2(scroll_container_position_x, scroll_container.position.y))
	
	var scroll_container_bottom_y_position: float = scroll_container.position.y + scroll_container.get_size().y
	
	# Starting positions for the next room to be generated
	# X = the Halfway position of room container - half the size of the longest floor to account for centering all of the rooms. 
	#	  Add a little padding to push it away from the right edge.
	# Y = Height of the Room Container that was calculated in room_container_height - (Screen Height - scroll container's bottom y position)
	var start_position_for_next_room_x: float = room_container.position.x + _padding_offset
	var start_position_for_next_room_y: float = room_container.get_custom_minimum_size().y - (color_rect.get_size().y - scroll_container_bottom_y_position)
	var position_for_next_room: Vector2 = Vector2(start_position_for_next_room_x, start_position_for_next_room_y)
	
	for floor: Array[RoomBase] in current_map.rooms:
		# When we're done populating a floor and we go to the next index, reset the X start position
		position_for_next_room.x = start_position_for_next_room_x
		for room: RoomBase in floor:
			if (room != null):
				var room_display: Control = room_ui.instantiate()
				room_container.add_child(room_display)
				room_display.set_label(room.get_room_abbreviation())
				room_display.position = position_for_next_room
			# When we go through the array of a floor to put a room down, 
			# increase the X position to the new potential area the room will be displayed on.
			position_for_next_room.x += new_room_size.x + _padding_offset
		# When we finish the array for a floor we need to go to the next floor up,
		# so increase the Y position to the new area the room will be displayed on.
		position_for_next_room.y -= new_room_size.y + _padding_offset
