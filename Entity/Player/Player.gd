extends Entity
class_name Player
## Base player Entity class.


func _ready() -> void:
	super()
	PlayerManager.set_player(self)


func _exit_tree() -> void:
	PlayerManager.set_player(null)
