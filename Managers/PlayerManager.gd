extends Node
## Global getter for the player.
##
## Since we only have one player, you can easily get the player from anywhere by calling
## PlayerManager.player.


var player: Player

signal on_player_initialized


func set_player(in_player: Player) -> void:
	player = in_player
	if player != null:
		on_player_initialized.emit()
