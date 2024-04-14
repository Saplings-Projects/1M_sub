extends Control
class_name MapUI

var map_scene: PackedScene = preload("res://#Scenes/CardScrollUI.tscn")
var room_ui: PackedScene = load("res://Map/RoomUI.tscn")

# DialogueManager add works essentially as a new packed scene with some extra functionality.
# Load up the dialog screen scene like we're switching to any normal scene.
# Then grab the dialog resource.
# We can pass in any .dialogue script here as long as it exists and it will work with the EventDialogueWindow.
# For testing, you replace test.dialogue or test2.dialogue and either one will work with the EventDialogueWindow scene.
var balloon_scene: PackedScene = load("res://Dialog/EventDialogueWindow.tscn")
var test_dialog: DialogueResource = load("res://Dialog/test.dialogue")

var _padding_offset: int = 20
var _MINIMUM_ROOM_WIDTH: int = 510
var _MINIMUM_ROOM_HEIGHT: int = 490

var _LIGHT_FLOOR_RANGE: int = 3

@export var room_with_player_texture: Texture2D
@export var color_rect: ColorRect
@export var scroll_container: SmoothScrollContainer
@export var room_container: ColorRect
@export var room_addition_node: Control
@export var torch_confirmation_dialog: ConfirmationDialog
@export var cant_set_torch_dialog: AcceptDialog
@export var player_position_not_set_text: String

var room_ui_array: Array[Array]
var current_player_room: RoomUI
var light_overlay: LightOverlay

func _input(_inputevent: InputEvent) -> void:
	if (_inputevent.is_action_pressed("cancel_action")):
		queue_free()


func _on_return_button_press() -> void:
	queue_free()
	

func _on_add_torch_pressed() -> void:
	if !PlayerManager.is_player_initial_position_set:
		cant_set_torch_dialog.dialog_text = player_position_not_set_text
		cant_set_torch_dialog.show()
	#TODO: Add in torch count here
	else:
		torch_confirmation_dialog.show()

func _close_torch_placement_dialog() -> void:
	torch_confirmation_dialog.hide()

# Add a torch to the current location the player is at,
# Also update the light level of all the rooms in range.
func _add_torch_to_current_location() -> void:
	var accessible_room_positions: Array[RoomBase] = MapMovement.get_all_accessible_rooms_in_range(PlayerManager.player_position, _LIGHT_FLOOR_RANGE, MapManager.current_map.rooms)
	for room: RoomBase in accessible_room_positions:
		room.light_data.increase_light_by_torch()
	current_player_room.room.set_torch_active()
	light_overlay.queue_redraw()

func _ready() -> void:
	# allows map to be closed if any of the room button on the map is pressed
	SignalBus.clicked_next_room_on_map.connect(_on_room_clicked)
	
	var current_map: MapBase = MapManager.current_map
	
	var accessible_rooms_by_player: Array[RoomBase] = []
	# Godot not happy and telling me current_map.rooms is an Array and not an Array[RoomBase]
	# because we can't have nested typing in array, so need to use assign for type conversion
	accessible_rooms_by_player.assign(current_map.rooms[0])
	if PlayerManager.is_player_initial_position_set:
		accessible_rooms_by_player = MapMovement.get_accessible_rooms_by_player()
	else:
		# If the player hasn't selected a room yet, take the currently accessible rooms 
		# (basically the rooms on the first floor) and increase the light on those rooms.
		for room: RoomBase in accessible_rooms_by_player:
			if room != null:
				room.light_data.increase_light_by_player_movement()
	
	# Create New Room Object to append to the room container
	var new_room: Control = room_ui.instantiate()
	var new_room_texture_button: TextureButton = Helpers.get_first_child_node_of_type(new_room, TextureButton)
	var new_room_size: Vector2 = new_room_texture_button.get_size()
	
	var room_container_width: float = _get_combined_room_width(new_room_texture_button)
	# Set the max width between what we calculated above and the minimum room width constant
	room_container_width = max(room_container_width, _MINIMUM_ROOM_WIDTH)
	
	var room_container_height: float = get_combined_room_height(new_room_texture_button)
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
	
	room_ui_array.resize(MapManager.map_width_array.size())
	
	for floor_index: int in range(current_map.rooms.size()):
		var floor_array: Array = current_map.rooms[floor_index]
		# When we're done populating a floor and we go to the next index, reset the X start position
		position_for_next_room.x = start_position_for_next_room_x
		for room: RoomBase in floor_array:
			if (room != null):
				var room_display: Control = room_ui.instantiate()
				var texture_button: TextureButton = Helpers.get_first_child_node_of_type(room_display, TextureButton)
				# disable the button if the player can't access the room
				texture_button.disabled = not (DebugVar.DEBUG_FREE_MOVEMENT or accessible_rooms_by_player.has(room))
				room_display.room = room
				if (PlayerManager.is_player_in_room(room)):
					current_player_room = room_display
					texture_button.disabled = true
					texture_button.texture_disabled = room_with_player_texture
				room_addition_node.add_child(room_display)
				room_display.set_label(room.get_room_abbreviation())
				room_display.position = position_for_next_room
				room_display.floor_index = floor_index
				room_ui_array[floor_index].append(room_display)
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
	var new_room_position_x: float = room_container.get_custom_minimum_size().x / 2 - _get_combined_room_width(new_room_texture_button) / 2
	
	# Get the offset if we had to adjust the X position due to having to set a minimum width if the map is too small.
	var offset_x: float = room_addition_node.position.x - new_room_position_x
	
	# If the height of the combined rooms is less than the minimum room height 
	# then calculate the position for it to be centered in the middle of the map:
	# We again want to place the rooms in the center of the container, but the y position of where the rooms are is relative to the container
	# Hence we subtract half the size of the container from half the size of the height of the combined rooms to get the center point
	# then subtract it from the position of the container
	var new_room_position_y: float = room_container.position.y
	# Get the offset if we had to adjust the Y position due to having to set a minimum height if the map is too small.
	var offset_y: float = 0
	if (get_combined_room_height(new_room_texture_button) < _MINIMUM_ROOM_HEIGHT):
		new_room_position_y = room_container.position.y - room_container.get_custom_minimum_size().y / 2 + get_combined_room_height(new_room_texture_button) / 2
		offset_y = room_addition_node.position.y - new_room_position_y
	room_addition_node.set_position(Vector2(new_room_position_x, new_room_position_y))
	
	new_room.free()
	
	light_overlay = LightOverlay.new(room_container, room_ui_array, offset_x, offset_y)
	room_container.add_child(light_overlay)
	
	if(!PlayerManager.is_player_initial_position_set):
		scroll_container.scroll_to_bottom(0)
	else:
		scroll_container.scroll_to_fauna(0)

# Get the width of room nodes, by getting the size of what a room is w/ some offset
# multiplying that by the max number in the map_width_array to get the width of the largest floor then add offset 
# to account for the other end of the floor
func _get_combined_room_width(texture_rect: TextureButton) -> float:
	return ((texture_rect.get_size().x + _padding_offset) * MapManager.map_width_array.max()) + _padding_offset

# Calculate the height of the container where the rooms will reside in. This will be dynamic based on the map array that we have.
# The array we have in MapManager, each element will increase the height of the map display, 
# multiply by the size of a room w/ some offset to dynamically set the size of the container of which we will be scrolling.
func get_combined_room_height(texture_rect: TextureButton) -> float:
	return MapManager.map_width_array.size() * (texture_rect.get_size().y + _padding_offset) + _padding_offset

# Callback function for when a player selects a room
# If the room hasn't been lit when we navigate there, then set it to dimly lit
func _on_room_clicked(clicked_room: RoomUI) -> void:
	current_player_room = clicked_room
	clicked_room.room.light_data.increase_light_by_player_movement()
	var player_adjacent_rooms: Array[RoomBase] = MapMovement.get_accessible_rooms_by_player()
	for room: RoomBase in player_adjacent_rooms:
		room.light_data.increase_light_by_player_movement()
		
	# If the debug flag to show the dialog screen is on, call the DialogueManager and show our dialogue.
	# The "test" refers to the chunk of dialog script we want the dialog to start at.
	if (DebugVar.DEBUG_TEST_DIALOGUE):
		DialogueManager.show_dialogue_balloon_scene(balloon_scene, test_dialog, "test")
	queue_free()
