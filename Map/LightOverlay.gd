extends Node2D
class_name LightOverlay

var color_array: PackedColorArray

var room_container: ColorRect
var room_ui_array: Array[Array]
var offset_position_y: float
var offset_position_x: float

var room_polygons_to_draw: Array[Rect2]

func _init(_room_container: ColorRect, _room_ui_array: Array[Array], _offset_position_x: float, _offset_position_y: float):
	room_container = _room_container
	room_ui_array = _room_ui_array
	offset_position_x = _offset_position_x
	offset_position_y = _offset_position_y

func _draw():
	var floor_rect_packed_array_top_half: PackedVector2Array
	var floor_rect_packed_array_bottom_half: PackedVector2Array
	var room_circles: Array[PackedVector2Array]
	var lit_rooms_to_draw: Array[RoomUI]
	var first_room_rect: Rect2
	
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
				if floor_index == 0:
					first_room_rect = room.get_room_rect()
					
	# Geometry2D.clip_polygons will only work if there are overlapping polygons, then we can get the inverse.
	# In the case where a room's radius fully encompasses then  we will get a fully black screen.
	# To remedy that, we break the darkness into two halves: first half is a rectangle from the top of the room container
	# First half is a rectangle from the top of the room container to the position of the very first room node created.
	# Second half is a rectangle that starts from the position of very first room node to the bottom of the room container
	floor_rect_packed_array_top_half.append(Vector2(0, 0))
	floor_rect_packed_array_top_half.append(Vector2(0, first_room_rect.position.y - offset_position_y))
	floor_rect_packed_array_top_half.append(Vector2(room_container.get_size().x, first_room_rect.position.y - offset_position_y))
	floor_rect_packed_array_top_half.append(Vector2(room_container.get_size().x, 0))
	
	floor_rect_packed_array_bottom_half.append(Vector2(0, first_room_rect.position.y - offset_position_y))
	floor_rect_packed_array_bottom_half.append(Vector2(0, room_container.get_size().y))
	floor_rect_packed_array_bottom_half.append(Vector2(room_container.get_size().x, room_container.get_size().y))
	floor_rect_packed_array_bottom_half.append(Vector2(room_container.get_size().x, first_room_rect.position.y - offset_position_y))
	
	# If we got room circles to draw, then draw em. This will not draw anything if we don't have a torch or a player position put down anywhere.
	if room_circles.size() > 0:
		# Create the polygon of all of the lit room circles. 
		var current_lit_room_polygon: PackedVector2Array = room_circles[0]
		for room_circle_index in range(room_circles.size()):
			if (room_circle_index + 1 <= room_circles.size() - 1):
				var merged_result = Geometry2D.merge_polygons(current_lit_room_polygon, room_circles[room_circle_index + 1])
				current_lit_room_polygon = merged_result[0]

		draw_polygon(current_lit_room_polygon, [Color(0, 0, 0, 0.25)])
		var outer_polygons_top_half = Geometry2D.clip_polygons(floor_rect_packed_array_top_half, current_lit_room_polygon)
		for outer in outer_polygons_top_half:
			draw_polygon(outer, [Color(0, 0, 0, 1)])
		var outer_polygons_bottom_half = Geometry2D.clip_polygons(floor_rect_packed_array_bottom_half, current_lit_room_polygon)
		for outer in outer_polygons_bottom_half:
			draw_polygon(outer, [Color(0, 0, 0, 1)])
	
	for room in lit_rooms_to_draw:
		_draw_room_circle(room)

var room_circle_radius = 40
func _draw_room_circle(room: RoomUI):
	var center_point: Vector2 = Vector2(room.get_center_X() - offset_position_x, room.get_center_Y() - offset_position_y)
	if room.get_light_level() == Enums.LightLevel.DIMLY_LIT:
		draw_circle(center_point, room_circle_radius, Color(0, 0, 0, 0.5))
	elif room.get_light_level() == Enums.LightLevel.LIT:
		draw_arc(center_point, room_circle_radius, 0, TAU, 20, Color(1, 1, 0, 1), 3)
		draw_circle(center_point, room_circle_radius - 1, Color(1, 1, 0, 0.1))

var outer_circle_radius = 60
# Function to get the points of a circle and return it as a PackedVector2Array
# This is needed to create the overall polygon for showing the rooms
func _calculate_points_for_circle(room: RoomUI) -> PackedVector2Array:
	var tick_count = 60
	var display_angle = 360
	var circle_points: PackedVector2Array
	for i in range(1, tick_count):
		# Generate an angle based off of the tick we are currently on
		var point_angle = -deg_to_rad(display_angle) + (TAU / tick_count) * i
		
		# Formula for getting a point on a circle:
		# x = r * cos(angle)
		# y = r * sin(angle)
		var x = outer_circle_radius * cos(point_angle)
		var y = outer_circle_radius * sin(point_angle)
		
		# Get the point of the circle, based off of the center point of where the room is, and the offset we need to take into account.
		var circle_point = Vector2(x + room.get_center_X() - offset_position_x, y + room.get_center_Y() - offset_position_y)
		circle_points.append(circle_point)
	return circle_points

