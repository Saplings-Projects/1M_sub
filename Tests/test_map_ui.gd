extends TestMapBase

var map_ui_scene: PackedScene = load("res://#Scenes/MapUI.tscn")
var map_ui: MapUI

func before_each() -> void:
	super()
	map_ui = map_ui_scene.instantiate()
	get_tree().root.add_child(map_ui)
	
func after_each() -> void:
	map_ui.queue_free()
	assert_no_new_orphans("Orphans still exist, please free up test resources.")
	
func test_map_initialize() -> void:
	assert_not_null(map_ui.color_rect, "Color Rect is not set")
	assert_not_null(map_ui.room_container, "Room Container is not set")
	assert_not_null(map_ui.scroll_container, "Scroll Container is not set")
	
	assert_null(map_ui.current_player_room, "Player room has not been set")
	
	assert_eq(map_ui.room_ui_array[0][2].room.light_data.light_level, Enums.LightLevel.DIMLY_LIT)

func test_player_placement() -> void:
	PlayerManager.player_position = Vector2i(2, 0)
	map_ui._on_room_clicked(map_ui.room_ui_array[0][2])
	
	for room_ui: RoomUI in map_ui.room_ui_array[1]:
		if room_ui != null:
			assert_eq(room_ui.room.light_data.light_level, Enums.LightLevel.DIMLY_LIT, "Adjacent room should be dimly lit")

func test_torch_placements() -> void:
	map_ui.room_ui_array[0][2]._set_player_position_based_on_room()
	
	assert_eq(map_ui.current_player_room.room.room_position, Vector2i(2, 0), "Player is in the wrong position")
	
	map_ui._add_torch_to_current_location()
	
	var rooms_in_range: Array[RoomBase] = MapMovement.get_all_accessible_rooms_in_range(PlayerManager.player_position, map_ui._LIGHT_FLOOR_RANGE, MapManager.current_map.rooms)
	assert_true(map_ui.room_ui_array[0][2].room.light_data.has_torch, "Current selected room should have a torch")
	for room: RoomBase in rooms_in_range:
		assert_eq(room.light_data.light_level, Enums.LightLevel.LIT, str("Room position ", room.room_position.y, ",", room.room_position.x, " should be lit"))

func test_movement_and_placing_two_torches() -> void:
	map_ui.room_ui_array[0][2]._set_player_position_based_on_room()
	
	map_ui._add_torch_to_current_location()
	
	map_ui.room_ui_array[1][1]._set_player_position_based_on_room()
	
	assert_eq(map_ui.current_player_room.room.room_position, Vector2i(1, 1), "Player is in the wrong position")
	
	map_ui._add_torch_to_current_location()
	var rooms_in_range: Array[RoomBase] = MapMovement.get_all_accessible_rooms_in_range(PlayerManager.player_position, map_ui._LIGHT_FLOOR_RANGE, MapManager.current_map.rooms)
	assert_true(map_ui.room_ui_array[1][1].room.light_data.has_torch, "Current selected room should have a torch")
	assert_eq(map_ui.room_ui_array[1][1].room.light_data.light_level, Enums.LightLevel.BRIGHTLY_LIT, "Current room should be brightly lit")
	for room: RoomBase in rooms_in_range:
		if room.room_position.y == 4:
			assert_eq(room.light_data.light_level, Enums.LightLevel.LIT, "This room was out of range of the previous torch put down, should be lit")
		else:
			assert_eq(room.light_data.light_level, Enums.LightLevel.BRIGHTLY_LIT, "This room was in range of the previous torch put down, should be brightly lit")

