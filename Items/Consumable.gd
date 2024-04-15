extends Resource

class_name Consumable

@export var name : String
@export var description : String
@export var image_path : String

func on_consume() -> void:
	print("consumed " + name)
