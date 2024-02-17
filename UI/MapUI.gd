extends Control

var map_scene: PackedScene = preload("res://#Scenes/CardScrollUI.tscn")
var room_ui: PackedScene = load("res://Map/RoomUI.tscn")
var _padding_offset: float = 25
var _MINIMUM_ROOM_WIDTH: float = 510
var _MINIMUM_ROOM_HEIGHT: float = 490
var _LIGHT_FLOOR_RANGE: int = 3

@export var color_rect: ColorRect
@export var scroll_container: SmoothScrollContainer
@export var room_container: ColorRect
@export var room_addition_node: Control
@export var torch_confirmation_dialog: ConfirmationDialog
@export var test_torch_indices: Array[Vector2]
@export var test_player_position: Vector2

var room_ui_array: Array[Array]
var current_player_room: RoomUI

func _input(_inputevent: InputEvent) -> void:
	if (_inputevent.is_action_pressed("cancel_action")):
		queue_free()


func _on_return_button_press() -> void:
	queue_free()
	

func _on_add_torch_pressed() -> void:
	torch_confirmation_dialog.show()

func _close_torch_placement_dialog() -> void:
	torch_confirmation_dialog.hide()

func _add_torch_to_current_location() -> void:
	var current_player_floor_index = current_player_room.floor_index
	var current_player_room_index = current_player_room.room_index
	
	var room_light_range = 1
	var max_light_index = current_player_floor_index + _LIGHT_FLOOR_RANGE + 1 
	
	if current_player_floor_index + _LIGHT_FLOOR_RANGE + 1 > MapManager.map_width_array.size():
		max_light_index = MapManager.map_width_array.size() 
	
	for floor_light_index: int in range(current_player_floor_index + 1, max_light_index):
		var minimum_room_light_index: int = current_player_room_index - room_light_range
		if current_player_room_index - room_light_range <= 0:
			minimum_room_light_index = 0
		var maximum_room_light_index: int = current_player_room_index + room_light_range + 1
		if current_player_room_index + room_light_range + 1 > MapManager.map_width_array.max():
			maximum_room_light_index = MapManager.map_width_array.max()
		for room_light_index: int in range(minimum_room_light_index, maximum_room_light_index):
			var room_ui: RoomUI = room_ui_array[floor_light_index][room_light_index]
			if room_ui != null:
				if floor_light_index == current_player_floor_index + 1 and room_ui.room.light_level == Enums.LightLevel.DIMLY_LIT:
					room_ui.room.set_light_level(Enums.LightLevel.BRIGHTLY_LIT)
				else:
					room_ui.room.set_light_level(Enums.LightLevel.DIMLY_LIT)
		room_light_range += 1
	current_player_room.room.set_torch_active()

# Test function
func _test_add_light_to_rooms(floor_index: int, room_index: int) -> void:
	var room_light_range = 1
	var max_light_index = floor_index + _LIGHT_FLOOR_RANGE + 1 
	if floor_index + _LIGHT_FLOOR_RANGE + 1 > MapManager.map_width_array.size():
		max_light_index = MapManager.map_width_array.size() 
	for floor_light_index: int in range(floor_index + 1, max_light_index):
		var minimum_room_light_index: int = room_index - room_light_range
		if room_index - room_light_range <= 0:
			minimum_room_light_index = 0
		var maximum_room_light_index: int = room_index + room_light_range + 1
		if room_index + room_light_range + 1 > MapManager.map_width_array.max():
			maximum_room_light_index = MapManager.map_width_array.max()
		for room_light_index: int in range(minimum_room_light_index, maximum_room_light_index):
			var room_ui: RoomUI = room_ui_array[floor_light_index][room_light_index]
			if (room_ui != null):
				room_ui.room.set_light_level(Enums.LightLevel.DIMLY_LIT)
		room_light_range += 1


func _ready():
	var current_map: MapBase = MapManager.current_map
	
	# Create New Room Object to append to the room container
	var new_room: Control = room_ui.instantiate()
	var new_room_texture_rect: TextureRect = Helpers.get_first_child_node_of_type(new_room, TextureRect)
	var new_room_size: Vector2 = new_room_texture_rect.get_size()
	
	
	var room_container_width: float = _get_combined_room_width(new_room_texture_rect)
	# Set the max width between what we calculated above and the minimum room width constant
	room_container_width = max(room_container_width, _MINIMUM_ROOM_WIDTH)
	
	var room_container_height: float = _get_combined_room_height(new_room_texture_rect)
	# Set the max height between what we calculated above and the minimum room height constant
	room_container_height = max(room_container_height, _MINIMUM_ROOM_HEIGHT)
	
	# Set the custom minimum size of the room container to allow scrolling
	room_container.set_custom_minimum_size(Vector2(room_container_width, room_container_height))
	
	# Set the size of the scroll container to be dynamic to the max numbers of rooms of a floor
	var container_size: Vector2 = Vector2(room_container_width, scroll_container.get_size().y)
	scroll_container.set_size(container_size)
	
	# We're dynamically sizing the width of the map, as such we need to position it to center it on the screen.
	# X position is calculated by getting half the width of the game screen, then subtracting that from 
	# half the width of the scroll_container 
	var scroll_container_position_x: float = color_rect.get_size().x / 2 - scroll_container.get_size().x / 2
	var container_position: Vector2 = Vector2(scroll_container_position_x, scroll_container.position.y)
	scroll_container.set_position(container_position)
	
	var scroll_container_bottom_y_position: float = scroll_container.position.y + scroll_container.get_size().y
	
	# Starting positions for the next room to be generated
	# X = the Halfway position of room container - half the size of the longest floor to account for centering all of the rooms. 
	#	  Add a little padding to push it away from the right edge.
	# Y = Height of the Room Container that was calculated in new_room_container_height - (Screen Height - scroll container's bottom y position)
	var start_position_for_next_room_x: float = room_container.position.x + _padding_offset
	var start_position_for_next_room_y: float = room_container.get_custom_minimum_size().y - (color_rect.get_size().y - scroll_container_bottom_y_position)
	var position_for_next_room: Vector2 = Vector2(start_position_for_next_room_x, start_position_for_next_room_y)
	
	var max_floor_width: int = MapManager.map_width_array.max()
	room_ui_array.resize(MapManager.map_width_array.size())
	
	var test_light_node: Array[LightNode]
	for floor_index: int in range(current_map.rooms.size()):
		var floor_array: Array = current_map.rooms[floor_index]
		# When we're done populating a floor and we go to the next index, reset the X start position
		position_for_next_room.x = start_position_for_next_room_x
		for room_index: int in range(floor_array.size()):
			var room: RoomBase = floor_array[room_index]
		#for room: RoomBase in floor_array:
			if room != null:
				var room_display: RoomUI = room_ui.instantiate()
				room_display.room = room
				room_addition_node.add_child(room_display)
				room_display.set_label(room.get_room_abbreviation())
				room_display.position = position_for_next_room
				room_display.floor_index = floor_index
				room_display.room_index = room_index
				if test_player_position != null and test_player_position.x == floor_index and test_player_position.y == room_index:
					current_player_room = room_display
					room_display.toggle_player_icon(true)
				room_ui_array[floor_index].append(room_display)
				var light_node_position: Vector2 = Vector2(position_for_next_room.x + new_room_size.x / 2, position_for_next_room.y + new_room_size.y / 2)
				var light: LightNode = LightNode.new(light_node_position, room_display)
				room_addition_node.add_child(light)
			else:
				room_ui_array[floor_index].append(null)
			# When we go through the array of a floor to put a room down, 
			# increase the X position to the new potential area the room will be displayed on.
			position_for_next_room.x += new_room_size.x + _padding_offset
		# When we finish the array for a floor we need to go to the next floor up,
		# so increase the Y position to the new area the room will be displayed on.
		position_for_next_room.y -= new_room_size.y + _padding_offset
	
	# Calculate the new position of where we should put the rooms after we populate the rooms out
	# We want to position the rooms in the center of the room container, to do so:
	# Get half the size of the room container and subtract it by half the size of the width of the combined rooms
	# This is to account for in case the size of the rooms is smaller than the container we put it in
	var new_room_position_x: float = room_container.get_custom_minimum_size().x / 2 - _get_combined_room_width(new_room_texture_rect) / 2
	
	# If the height of the combined rooms is less than the minimum room height 
	# then calculate the position for it to be centered in the middle of the map:
	# We again want to place the rooms in the center of the container, but the y position of where the rooms are is relative to the container
	# Hence we subtract half the size of the container from half the size of the height of the combined rooms to get the center point
	# then subtract it from the position of the container
	var new_room_position_y: float = room_container.position.y
	if (_get_combined_room_height(new_room_texture_rect) < _MINIMUM_ROOM_HEIGHT):
		new_room_position_y = room_container.position.y - room_container.get_custom_minimum_size().y / 2 + _get_combined_room_height(new_room_texture_rect) / 2
	room_addition_node.set_position(Vector2(new_room_position_x, new_room_position_y))
	
	if test_torch_indices.size() > 0:
		for test_torch: Vector2 in test_torch_indices:
			var room_ui: RoomUI = room_ui_array[test_torch.x][test_torch.y]
			if room_ui != null:
				room_ui.room.set_torch_active()
				_test_add_light_to_rooms(test_torch.x, test_torch.y)

# Get the width of room nodes, by getting the size of what a room is w/ some offset
# multiplying that by the max number in the map_width_array to get the width of the largest floor then add offset 
# to account for the other end of the floor
func _get_combined_room_width(texture_rect: TextureRect) -> float:
	return ((texture_rect.get_size().x + _padding_offset) * MapManager.map_width_array.max()) + _padding_offset

# Calculate the height of the container where the rooms will reside in. This will be dynamic based on the map array that we have.
# The array we have in MapManager, each element will increase the height of the map display, 
# multiply by the size of a room w/ some offset to dynamically set the size of the container of which we will be scrolling.
func _get_combined_room_height(texture_rect: TextureRect) -> float:
	return MapManager.map_width_array.size() * (texture_rect.get_size().y + _padding_offset) + _padding_offset
