extends Resource
class_name QueueItem

# Variables
var id: String
var title: String
var title_en: String
var description: String
var description_en: String
var category: String
var tree: TreeNode

# Variables for historical context
var historical_year: int = 0
var historical_significance: String = ""
var historical_url: String = ""

# Check if this queue item has a historical context
func has_historical_context() -> bool:
	return historical_year > 0 or historical_significance != "" or historical_url != ""

# Get QueueItem as string
func _to_string() -> String:
	var tree_info = "null"
	if tree != null and tree.values != null:
		tree_info = tree.values.id
	return "QueueItem(id=%s, title=%s, category=%s, tree=%s)" % [id, title, category, tree_info]
