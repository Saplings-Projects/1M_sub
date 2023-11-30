extends Node
class_name Helpers
## A place for helpful functions we can use globally.


static func get_child_node_of_type(node : Node, type : Variant) -> Variant:
	for child in node.get_children():
		if is_instance_of(child, type):
			return child
	return null
