extends Resource
class_name TreeNode

var values: _TreeValues
var children: Array = []

func _init(_values: _TreeValues = null):
	values = _values
	children = []

func add_child(node: TreeNode) -> void:
	children.append(node)

func remove_child(node: TreeNode) -> void:
	children = children.filter(func(c): return c != node)

func _to_string(level: int = 0) -> String:
	var indent = "  ".repeat(level)
	var ret = indent + str(values) + "\n"
	for child in children:
		ret += child._to_string(level + 1)
	return ret
