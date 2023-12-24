class_name StatModifiers extends Resource

var modifiers: Dictionary = {}

func _init() -> void:
    modifiers = {   
                    "permanent_add":        0,  # int
                    "permanent_multiply":   1,  # float
                    "temporary_add":        0,  # int
                    "temporary_multiply":   1   # float
                }

func reset_temp_to_default() -> void:
    modifiers["temporary_add"] = 0
    modifiers["temporary_multiply"] = 1

func change_modifier(   add_to_perm: int = 0, 
                        mult_to_perm: float = 1, 
                        add_to_temp: int = 0, 
                        mult_to_temp: float = 1
                        ) -> void:
    modifiers["permanent_add"] += add_to_perm
    modifiers["permanent_multiply"] *= mult_to_perm
    modifiers["temporary_add"] += add_to_temp
    modifiers["temporary_multiply"] *= mult_to_temp

