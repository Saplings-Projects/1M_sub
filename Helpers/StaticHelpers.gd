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
