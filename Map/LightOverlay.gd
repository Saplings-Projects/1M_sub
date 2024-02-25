extends Node2D
class_name LightOverlay

var room_container: ColorRect
var room_ui_array: Array[Array]

# Save an offset when the rooms generated are too small and we have to set a minimum width/height to position the lit rooms properly
var offset_position_y: float
var offset_position_x: float

func _init(_room_container: ColorRect, _room_ui_array: Array[Array], _offset_position_x: float, _offset_position_y: float):
	room_container = _room_container
	room_ui_array = _room_ui_array
	offset_position_x = _offset_position_x
	offset_position_y = _offset_position_y

func _draw():
	var room_circles: Array[PackedVector2Array]
	var lit_rooms_to_draw: Array[RoomUI]
	var first_room_rect: Rect2
	
	# Iterating through the room array, if there is a lit room create a circular polygon PackedVector2 array
	for floor_array: Array[RoomUI] in room_ui_array:
		for room: RoomUI in floor_array:
			if room != null:
				if (room.get_light_level() != Enums.LightLevel.UNLIT):
					room_circles.append(_calculate_points_for_circle(room))
					lit_rooms_to_draw.append(room)
				# Save the first room in the map, to help with the calculations of the darkness overlay
				if first_room_rect == null:
					first_room_rect = room.get_room_rect()
					
	# Geometry2D.clip_polygons will only work if there are overlapping polygons, then we can get the inverse.
	# In the case where a room's radius fully encompasses then  we will get a fully black screen.
	# To remedy that, we break the darkness into two halves:
	# First half (map_upper_half) is a rectangle from the top of the map container to the position of the very first room node created.
	# Second half (map_bottom_half) is a rectangle that starts from the position of very first room node to the bottom of the map container
	var map_upper_half: PackedVector2Array
	var map_bottom_half: PackedVector2Array
	map_upper_half.append(Vector2(0, 0))
	map_upper_half.append(Vector2(0, first_room_rect.position.y - offset_position_y))
	map_upper_half.append(Vector2(room_container.get_size().x, first_room_rect.position.y - offset_position_y))
	map_upper_half.append(Vector2(room_container.get_size().x, 0))
	
	map_bottom_half.append(Vector2(0, first_room_rect.position.y - offset_position_y))
	map_bottom_half.append(Vector2(0, room_container.get_size().y))
	map_bottom_half.append(Vector2(room_container.get_size().x, room_container.get_size().y))
	map_bottom_half.append(Vector2(room_container.get_size().x, first_room_rect.position.y - offset_position_y))
	
	# If we got room circles to draw, then draw em. 
	# This will not draw anything if we don't have a torch or a player position put down anywhere.
	if room_circles.size() > 0:
		# Create the outer polygon of all of the lit room circles.
		# Get the first element of the lit room circles, 
		# then iterate through the array, getting the next room circle and merging the polygons togetgher to get one polygon,
		# while assigning it to the current_polygon.
		var current_lit_room_polygon: PackedVector2Array = room_circles[0]
		for room_circle_index: int in range(room_circles.size()):
			if (room_circle_index + 1 <= room_circles.size() - 1):
				var merged_result = Geometry2D.merge_polygons(current_lit_room_polygon, room_circles[room_circle_index + 1])
				current_lit_room_polygon = merged_result[0]
		draw_polygon(current_lit_room_polygon, [Color(0, 0, 0, 0.25)])
		
		# From the finished merged polygon blob from the lit room circles we created above, 
		# Get the polygon inverse of the black overlay with the merged polygon blob we created above then draw them out.
		var outer_polygons_upper_half: Array[PackedVector2Array] = Geometry2D.clip_polygons(map_upper_half, current_lit_room_polygon)
		for outer: PackedVector2Array in outer_polygons_upper_half:
			draw_polygon(outer, [Color(0, 0, 0, 1)])
		var outer_polygons_bottom_half: Array[PackedVector2Array] = Geometry2D.clip_polygons(map_bottom_half, current_lit_room_polygon)
		for outer: PackedVector2Array in outer_polygons_bottom_half:
			draw_polygon(outer, [Color(0, 0, 0, 1)])
	
	for room: RoomUI in lit_rooms_to_draw:
		_draw_room_circle(room)

var room_circle_radius: int = 40
func _draw_room_circle(room: RoomUI):
	var center_point_with_offset: Vector2 = Vector2(room.get_center_X() - offset_position_x, room.get_center_Y() - offset_position_y)
	# Discussions on customization with adding gradient to be done here. Currently we draw a circle around
	# rooms that have a torch, and a rect around rooms that are lit from a torch
	if room.has_torch():
		# These draw calls draw an unfilled circle around the room with with a thicker width, 
		# then a filled circle on the inside that's filled in, with small transparency
		if room.get_light_level() == Enums.LightLevel.LIT:
			draw_arc(center_point_with_offset, room_circle_radius, 0, TAU, 20, Color(1, 1, 0, 1), 3)
			draw_circle(center_point_with_offset, room_circle_radius - 1, Color(1, 1, 0, 0.01))
		elif room.get_light_level() == Enums.LightLevel.BRIGHTLY_LIT:
			draw_arc(center_point_with_offset, room_circle_radius, 0, TAU, 20, Color(0, 1, 1, 1), 3)
			draw_circle(center_point_with_offset, room_circle_radius - 1, Color(0, 1, 1, 0.01))
	else:
		if room.get_light_level() == Enums.LightLevel.DIMLY_LIT:
			draw_rect(room.get_room_rect().grow(-3), Color(0, 0, 0, 0.5), true)
		elif room.get_light_level() == Enums.LightLevel.LIT:
			draw_rect(room.get_room_rect().grow(3), Color(1, 1, 0, 1), false)
		elif room.get_light_level() == Enums.LightLevel.BRIGHTLY_LIT:
			draw_rect(room.get_room_rect().grow(3), Color(0, 1, 1, 1), false)

var outer_circle_radius: int = 60
# Function to get the points of a circle and return it as a PackedVector2Array
# This is needed to create the overall polygon for showing the rooms
func _calculate_points_for_circle(room: RoomUI) -> PackedVector2Array:
	var tick_count: int = 60
	var display_angle: int = 360
	var circle_points: PackedVector2Array
	for tick: int in range(1, tick_count):
		# Generate an angle based off of the tick we are currently on
		# As we increase in tick amount, we will eventually be at the circumference of a circle
		# However, since TAU is in radians, we need to convert the angle we define to be in radians first.
		var point_angle = deg_to_rad(display_angle) + (TAU / tick_count) * tick
		
		# Formula for getting a point on a circle:
		# x = r * cos(angle)
		# y = r * sin(angle)
		var x: float = outer_circle_radius * cos(point_angle)
		var y: float = outer_circle_radius * sin(point_angle)
		
		# Get the point of the circle, based off of the center point of where the room is, and the offset we need to take into account.
		var circle_point: Vector2 = Vector2(x + room.get_center_X() - offset_position_x, y + room.get_center_Y() - offset_position_y)
		circle_points.append(circle_point)
	return circle_points

