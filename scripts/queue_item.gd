extends Resource
class_name QueueItem

var id: String
var title: String
var description: String
var tree_id: String

# Get QueueItem as string
func _to_string() -> String:
	return "QueueItem(id=%s, title=%s, description=%s, tree_id=%s)" % [id, title, description, tree_id]
