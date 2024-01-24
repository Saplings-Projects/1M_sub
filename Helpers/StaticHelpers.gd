extends Node
class_name Helpers
## A place for helpful functions we can use globally.


static func get_first_child_node_of_type(node: Node, type: Variant) -> Variant:
	for child: Variant in node.get_children():
		if is_instance_of(child, type):
			return child
	return null


static func find_first_from_array_by_type(array: Array[Variant], type: Variant) -> Variant:
	for value: Variant in array:
		if is_instance_of(value, type):
			return value
	return null


static func get_random_array_index(array: Array[Variant]) -> int:
	return randi_range(0, array.size() - 1)


static func convert_from_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	var from_range: float = from_max - from_min
	var to_value: float = 0.0
	
	if from_range == 0.0:
		return to_min
	else:
		var to_range: float = to_max - to_min
		to_value = (((value - from_min) * to_range) / from_range) + to_min
	
	return to_value


# Recursive versions of inst_to_dict and dict_to_inst
# https://github.com/Rinkton/godot-improved-dict-inst-converter/tree/main?tab=MIT-1-ov-file
static func inst_to_dict_recursive(inst : Object) -> Dictionary:
	var dict := inst_to_dict(inst)
	var i := 2
	while i < len(dict):
		var key = dict.keys()[i]
		var value = dict.values()[i]
		if typeof(value) == TYPE_OBJECT:
			dict[key] = inst_to_dict(value)
		elif typeof(value) == TYPE_ARRAY:
			dict[key] = _insts_to_dicts(value)
		i+=1
	return dict


static func dict_to_inst_recursive(dict : Dictionary) -> Object:
	var i := 2
	while i < len(dict):
		var key = dict.keys()[i]
		var value = dict.values()[i]
		if typeof(value) == TYPE_DICTIONARY:
			dict[key] = dict_to_inst(value)
		elif typeof(value) == TYPE_ARRAY:
			dict[key] = _dicts_to_insts(value)
		i+=1
	var inst := dict_to_inst(dict)
	var node : Node
	if inst.has_method("get_tscn"):
		node = load(inst.get_tscn()).instance()
	else:
		return inst
	i = 2
	while i < len(dict):
		var key = dict.keys()[i]
		var value = dict.values()[i]
		node.set(key, value)
		i+=1
	return node


static func _insts_to_dicts(arr : Array) -> Array:
	var dict_arr := []
	for elem in arr:
		if typeof(elem) == TYPE_OBJECT:
			var dict := inst_to_dict_recursive(elem)
			dict_arr.append(dict)
		else:
			return arr
	return dict_arr


static func _dicts_to_insts(arr : Array) -> Array:
	var inst_arr := []
	for elem in arr:
		if typeof(elem) == TYPE_DICTIONARY:
			var inst := dict_to_inst_recursive(elem)
			inst_arr.append(inst)
		else:
			return arr
	return inst_arr
