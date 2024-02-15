extends Node
## Global getter for the player.
##
## Since we only have one player, you can easily get the player from anywhere by calling
## PlayerManager.player.


var player: Player
var player_position: Vector2i

signal on_player_initialized


func set_player(in_player: Player, in_player_position: Vector2i) -> void:
	player = in_player
	player_position = in_player_position
	if player != null:
		on_player_initialized.emit()
