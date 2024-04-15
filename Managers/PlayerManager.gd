extends Node
## Global getter for the player.
##
## Since we only have one player, you can easily get the player from anywhere by calling
## PlayerManager.player.

signal on_player_initialized

var player: Player

## This is updated when a room button on the MapUI is clicked. [br]
## The actual connection is done via the ready function that sends a signal in the [RoomUI] [br]
var player_position: Vector2i = Vector2i(-1,-1):
	set(position):
		player_position = position
		is_player_initial_position_set = true
	get:
		return player_position

var is_player_initial_position_set: bool

## A flag to check if the player is allowed to move on the map. [br]
## This is set to false at the start of an event, and set to true once the event ends [br]
## This is set to true by default as it allows the player to move to the first floor of the map
var is_map_movement_allowed: bool = true

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
	

func is_player_in_room(room: RoomBase) -> bool:
	if room == null:
		return false
		
	var map_rooms: Array[Array] = MapManager.current_map.rooms
	
	return room == map_rooms[player_position.y][player_position.x]
