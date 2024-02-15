extends Node
## Global getter for the player.
##
## Since we only have one player, you can easily get the player from anywhere by calling
## PlayerManager.player.


signal on_player_initialized

var player: Player
var player_persistent_data: PlayerPersistentData = null:
	get:
		return player_persistent_data


func set_player(in_player: Player) -> void:
	player = in_player
	if player != null:
		on_player_initialized.emit()


func create_persistent_data() -> void:
	player_persistent_data = PlayerPersistentData.new()
