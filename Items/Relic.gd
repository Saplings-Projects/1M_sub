extends Resource
class_name Relic

@export var name : String
@export var description : String
@export var sprite_path : String

func on_get() -> void:
	print("got " + name)
	#TODO

func on_lose() -> void:
	print("lost " + name)
	#TODO
