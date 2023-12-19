extends EventBase
class_name EventMob

# @Override
func _init(scene: String) -> void:
	super(scene)
	
# @Override
func _update_event() -> void:
	print("Update Mob")
