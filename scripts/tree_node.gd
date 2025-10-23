extends Resource
class_name TreeNode

# Variables
var values: _TreeValues
var option_values: OptionValues
var children: Array = []
var is_option_node: bool = false

# Initializing TreeNode
func _init(_values: _TreeValues = null, _option_values: OptionValues = null):
	values = _values
	option_values = _option_values
	children = []
	is_option_node = (_option_values != null)

# Add a child
func add_child(node: TreeNode) -> void:
	children.append(node)

# Remove a child
func remove_child(node: TreeNode) -> void:
	children = children.filter(func(c): return c != node)

# Get TreeNode as string
func _to_string(level: int = 0) -> String:
	var indent: String = "  ".repeat(level)
	var ret: String = ""
	
	if is_option_node and option_values != null:
		ret = indent + "[OPTION] " + str(option_values) + "\n"
	elif values != null:
		ret = indent + str(values) + "\n"
	
	for child in children:
		ret += child._to_string(level + 1)
	return ret
