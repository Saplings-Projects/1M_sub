extends Resource

class_name Consumable

## placeholder class, will need to be fleshed out later

@export var name : String
@export var description : String
@export var image_path : String

func on_consume() -> void:
	print("consumed " + name)
	#TODO
