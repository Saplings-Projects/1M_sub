extends Node
class_name Helpers
## A place for helpful functions we can use globally.


## Gets the first child node of a given node by it's type
static func get_first_child_node_of_type(node: Node, type: Variant) -> Variant:
	for child: Variant in node.get_children():
		if is_instance_of(child, type):
			return child
	return null


## Gets all children nodes of a given node by it's type
static func get_all_children_nodes_of_type(node: Node, type: Variant) -> Array[Variant]:
	var children: Array[Variant] = []
	for child: Variant in node.get_children():
		if is_instance_of(child, type):
			children.append(child)
	return children


## Find the first element of a given type in an array
static func find_first_from_array_by_type(array: Array[Variant], type: Variant) -> Variant:
	for value: Variant in array:
		if is_instance_of(value, type):
			return value
	return null


## Get a index between 0 and the size of the array -1
static func get_random_array_index(array: Array[Variant]) -> int:
	return randi_range(0, array.size() - 1)


## Linear mapping of a range [a,b] to range [c,d] (with a mapping to c and b mapping to d)
static func convert_from_range(value: float, from_min: float, from_max: float, to_min: float, to_max: float) -> float:
	var from_range: float = from_max - from_min
	var to_value: float = 0.0
	
	if from_range == 0.0:
		return to_min
	else:
		var to_range: float = to_max - to_min
		to_value = (((value - from_min) * to_range) / from_range) + to_min
	
	return to_value


## Generate the average vector of a list of vectors
static func get_mean_vector(positions: Array[Vector2]) -> Vector2:
	if positions.size() <= 0:
		return Vector2.ZERO
	var mean_vector: Vector2 = Vector2.ZERO
	for position: Vector2 in positions:
		mean_vector += position
	return mean_vector / positions.size()



## Remove duplicates from an array [br]
## ! works in place
static func remove_duplicate_in_array(array: Array) -> void:
	var dict: Dictionary = {}
	for value: Variant in array:
		dict[value] = 1 # value doesn't matter, we just need the keys
	array.assign(dict.keys())
