class_name StatModifiers extends Resource

var modifiers: Dictionary = {}

func _init() -> void:
    modifiers = {   
                    "permanent_add":        0,  # int
                    "permanent_multiply":   1,  # float
                    "temporary_add":        0,  # int
                    "temporary_multiply":   1   # float
                }