class_name StatModifiers extends Resource

var modifier_base_dict: Dictionary = {}

@export var permanent_add: int = 0
@export var permanent_multiply: float = 1
@export var temporary_add: int = 0
@export var temporary_multiply: float = 1

var _MODIFIER_KEYS : Dictionary = GlobalVar.MODIFIER_KEYS
# shorter to write

func _init( _permanent_add: int = permanent_add, 
			_permanent_multiply: float = permanent_multiply, 
			_temporary_add: int = temporary_add, 
			_temporary_multiply: float = temporary_multiply) -> void:
	modifier_base_dict = {   
					_MODIFIER_KEYS.PERMANENT_ADD:        _permanent_add,  # int
					_MODIFIER_KEYS.PERMANENT_MULTIPLY:   _permanent_multiply,  # float
					_MODIFIER_KEYS.TEMPORARY_ADD:        _temporary_add,  # int
					_MODIFIER_KEYS.TEMPORARY_MULTIPLY:   _temporary_multiply   # float
				}
# the parameter call is a bit convoluted, but this allows to both modify via export
# and via the constructor when calling new() in code

func reset_temp_to_default() -> void:
	modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_ADD] = 0
	modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_MULTIPLY] = 1

func change_modifier(new_modification: StatModifiers) -> void:
	modifier_base_dict[_MODIFIER_KEYS.PERMANENT_ADD] += new_modification.modifier_base_dict[_MODIFIER_KEYS.PERMANENT_ADD]
	modifier_base_dict[_MODIFIER_KEYS.PERMANENT_MULTIPLY] *= new_modification.modifier_base_dict[_MODIFIER_KEYS.PERMANENT_MULTIPLY]
	modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_ADD] += new_modification.modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_ADD]
	modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_MULTIPLY] *= new_modification.modifier_base_dict[_MODIFIER_KEYS.TEMPORARY_MULTIPLY]

