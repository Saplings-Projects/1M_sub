extends Resource
class_name Event

var EVENTS_CLASSIFICATION = [Event_Mob, Event_Random, Event_Shop, Event_Heal]

# Initialize Event
func _init():
	print("Initialize Event")
	
func _update():
	print("Update")
