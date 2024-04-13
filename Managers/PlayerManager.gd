extends Node
## Global getter for the player.
##
## Since we only have one player, you can easily get the player from anywhere by calling
## PlayerManager.player.

signal on_player_initialized

var player: Player

## The position of the player on the map (by default, a position that doesn't exist)
var player_position: Vector2i = Vector2i(-1,-1):
	set(position):
		player_position = position
		is_player_initial_position_set = true
	get:
		return player_position

## Check if the player has selected a starting position
var is_player_initial_position_set: bool

var player_persistent_data: PlayerPersistentData = null:
	get:
		return player_persistent_data


func _ready() -> void:
	player = null
	is_player_initial_position_set = false




func set_player(in_player: Player) -> void:
	player = in_player
	if player != null:
		on_player_initialized.emit()


func create_persistent_data() -> void:
	player_persistent_data = PlayerPersistentData.new()
	

## Checks if the player is in a given room
func is_player_in_room(room: RoomBase) -> bool:
	if room == null:
		return false
		
	var map_rooms: Array[Array] = MapManager.current_map.rooms
	
	return room == map_rooms[player_position.y][player_position.x]
