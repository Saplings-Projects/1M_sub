extends EventBase
class_name EventRandom

# @Override
func _init(scene: String) -> void:
	super(scene)
	
# @Override
func _update_event() -> void:
	print("Updating Random Event")
