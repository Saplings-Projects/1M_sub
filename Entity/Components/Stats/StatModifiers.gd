class_name StatModifiers extends Resource

var modifiers: Dictionary = {}

@export var permanent_add: int = 0
@export var permanent_multiply: float = 1
@export var temporary_add: int = 0
@export var temporary_multiply: float = 1 

func _init( _permanent_add: int = permanent_add, 
			_permanent_multiply: float = permanent_multiply, 
			_temporary_add: int = temporary_add, 
			_temporary_multiply: float = temporary_multiply) -> void:
	modifiers = {   
					"permanent_add":        _permanent_add,  # int
					"permanent_multiply":   _permanent_multiply,  # float
					"temporary_add":        _temporary_add,  # int
					"temporary_multiply":   _temporary_multiply   # float
				}
# the parameter call is a bit convoluted, but this allows to both modify via export
# and via the constructor when calling new() in code

func reset_temp_to_default() -> void:
	modifiers["temporary_add"] = 0
	modifiers["temporary_multiply"] = 1

func change_modifier(new_modification: StatModifiers) -> void:
	modifiers["permanent_add"] += new_modification.modifiers["permanent_add"]
	modifiers["permanent_multiply"] *= new_modification.modifiers["permanent_multiply"]
	modifiers["temporary_add"] += new_modification.modifiers["temporary_add"]
	modifiers["temporary_multiply"] *= new_modification.modifiers["temporary_multiply"]

