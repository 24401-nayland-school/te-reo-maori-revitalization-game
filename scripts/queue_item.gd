extends Resource
class_name QueueItem

var id: String
var title: String
var description: String
var tree: TreeNode

# Get QueueItem as string
func _to_string() -> String:
	var tree_info = "null"
	if tree != null and tree.values != null:
		tree_info = tree.values.id
	return "QueueItem(id=%s, title=%s, description=%s, tree=%s)" % [id, title, description, tree_info]
