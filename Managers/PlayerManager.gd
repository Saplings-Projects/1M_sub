extends Node
## Global getter for the player.
##
## Since we only have one player, you can easily get the player from anywhere by calling
## PlayerManager.player.

signal on_player_initialized

var player: Player
var player_position: Vector2i


func _ready() -> void:
	player = null
	MapManager.map_initialized.connect(_set_starting_position)
	

func _set_starting_position() -> void:
	player_position = _get_starting_position()


func set_player(in_player: Player) -> void:
	player = in_player
	if player != null:
		on_player_initialized.emit()
		

func _get_starting_position() -> Vector2i:
	var current_map_width_array: Array[int] = MapManager.map_width_array
	var starting_position: Vector2i = Vector2i(0,0)
	
	var padding_size_first_floor: int = (current_map_width_array.max() - current_map_width_array[0])/2
	
	starting_position.x = padding_size_first_floor
	
	return starting_position
	

func is_player_in_room(room: RoomBase) -> bool:
	if room == null:
		return false
		
	var map_rooms: Array[Array] = MapManager.current_map.rooms
	
	return room == map_rooms[player_position.y][player_position.x]
