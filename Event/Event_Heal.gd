extends Event
class_name Event_Heal

# @Override
func _init(scene: String) -> void:
	super(scene)
	
# @Override
func _update_event() -> void:
	print("Updating Heal Event")
