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
	player_position = Vector2i(5, 0)


func set_player(in_player: Player) -> void:
	player = in_player
	if player != null:
		on_player_initialized.emit()
