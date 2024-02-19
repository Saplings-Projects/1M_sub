extends Node2D
class_name LightOverlay

var color_array: PackedColorArray

var room_container: ColorRect
var room_ui_array: Array[Array]

var room_polygons_to_draw: Array[Rect2]

func _init(_room_container: ColorRect, _room_ui_array: Array[Array]):
	room_container = _room_container
	room_ui_array = _room_ui_array

func _draw():
	var floor_rect_packed_array: PackedVector2Array
	var room_circles: Array[PackedVector2Array]
	var lit_rooms_to_draw: Array[RoomUI]
	
	# Account for minimum map placement T____T
	for floor_index: int in range(room_ui_array.size()):
		var floor_array: Array = room_ui_array[floor_index]
		var _first_room_in_array: bool = false
		
		for room_index: int in range(floor_array.size()):
			var room: RoomUI = floor_array[room_index]
			if room != null:
				var new_room_texture_rect: TextureRect = Helpers.get_first_child_node_of_type(room, TextureRect)
				var room_size = new_room_texture_rect.get_size()
				if (room.get_light_level() != Enums.LightLevel.UNLIT):
					room_circles.append(_calculate_points_for_circle(room))
					lit_rooms_to_draw.append(room)
	floor_rect_packed_array.append(Vector2(0, 0))
	floor_rect_packed_array.append(Vector2(0, room_container.get_size().y))
	floor_rect_packed_array.append(Vector2(room_container.get_size().x, room_container.get_size().y))
	floor_rect_packed_array.append(Vector2(room_container.get_size().x, 0))
	
	if room_circles.size() > 0:
		var current_lit_room_polygon: PackedVector2Array = room_circles[0]
		for room_circle_index in range(room_circles.size()):
			if (room_circle_index + 1 <= room_circles.size() - 1):
				var merged_result = Geometry2D.merge_polygons(current_lit_room_polygon, room_circles[room_circle_index + 1])
				current_lit_room_polygon = merged_result[0]

		draw_polygon(current_lit_room_polygon, [Color(0, 0, 0, 0.25)])
		var outer_polygons = Geometry2D.clip_polygons(floor_rect_packed_array, current_lit_room_polygon)
		for outer in outer_polygons:
			draw_polygon(outer, [Color(0, 0, 0, 1)])
	
	for room in lit_rooms_to_draw:
		_draw_room_circle(room)


func _draw_room_circle(room: RoomUI):
	if room.get_light_level() == Enums.LightLevel.DIMLY_LIT:
		#draw_circle(Vector2(room.get_center_X(), room.get_center_Y()), 60, Color(0, 0, 0, 0.5))
		draw_rect(room.get_room_rect(), Color(0, 0, 0, 0.5))
	elif room.get_light_level() == Enums.LightLevel.LIT:
		draw_arc(Vector2(room.get_center_X(), room.get_center_Y()), 40, 0, TAU, 20, Color(1, 1, 0, 1), 3)
		draw_circle(Vector2(room.get_center_X(), room.get_center_Y()), 39, Color(1, 1, 0, 0.1))

func _calculate_points_for_circle(room: RoomUI) -> PackedVector2Array:
	var rect: TextureRect = Helpers.get_first_child_node_of_type(room, TextureRect)
	var rect_size = rect.get_size()
	var center_point = Vector2(room.position.x + rect.get_size().x / 2, room.position.y + rect.get_size().y / 2)
	var tick_count = 60
	var display_angle = 360
	var circle_points: PackedVector2Array
	for i in range(1, tick_count):
		var point_angle = -deg_to_rad(display_angle) / tick_count * i
		point_angle = -deg_to_rad(display_angle) + (2 * PI / tick_count) * i
		var x = (rect_size.x + 60 * cos(point_angle)) - rect_size.x / 2.0
		var y = (rect_size.y + 60 * sin(point_angle)) - rect_size.y / 2.0
		var circle_point = Vector2(x + room.position.x, y + room.position.y)
		circle_points.append(circle_point)
	return circle_points

