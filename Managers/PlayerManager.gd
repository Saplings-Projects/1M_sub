extends Node
## Global getter for the player.
##
## Since we only have one player, you can easily get the player from anywhere by calling
## PlayerManager.player.


signal on_player_initialized

var player: Player


func set_player(in_player: Player) -> void:
	player = in_player
	if player != null:
		on_player_initialized.emit()


func save_player_data(save_data: SaveData):
	save_data.saved_hp = player.get_health_component().current_health
