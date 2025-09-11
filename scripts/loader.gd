extends Node
class_name Loader

# Load Queue from file path
static func load_queue(file_path: String, trees_file_path: String) -> Queue:
	var queue: Queue = Queue.new()
	
	var trees: Dictionary = load_trees(trees_file_path)
	
	if FileAccess.file_exists(file_path):
		var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var json_text: String = file.get_as_text()
		file.close()
		
		var json: JSON = JSON.new()
		var error: Error = json.parse(json_text)
		if error == OK:
			var data: Variant = json.data
			for q_data in data:
				var item: QueueItem = QueueItem.new()
				item.id = q_data.get("id", "")
				item.title = q_data.get("title", "")
				item.description = q_data.get("description", "")
				var tree_id = q_data.get("tree_id", "")
				if tree_id == null:
					tree_id = ""
				
				if tree_id != "" and trees.has(tree_id):
					item.tree = trees[tree_id]
				else:
					item.tree = null
				
				queue.enqueue(item)
		else:
			push_error("Failed to parse JSON: %s" % json.get_error_message())
	else:
		push_error("File does not exist: %s" % file_path)
	
	return queue

static func load_trees(file_path: String) -> Dictionary:
	var trees: Dictionary = {}
	
	if FileAccess.file_exists(file_path):
		var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var json_text: String = file.get_as_text()
		file.close()
		
		var json: JSON = JSON.new()
		var error: Error = json.parse(json_text)
		if error == OK:
			var data: Variant = json.data
			
			for tree_data in data:
				var tree_node: TreeNode = TreeNode.new()
				var values: _TreeValues = _TreeValues.new()
				values.id = tree_data.get("id", "")
				values.title = tree_data.get("title", "")
				values.description = tree_data.get("description", "")
				tree_node.values = values
				trees[values.id] = tree_node
			
			for tree_data in data:
				var tree_id: String = tree_data.get("id", "")
				var current_tree: TreeNode = trees[tree_id]
				var options: Array = tree_data.get("options", [])
				
				for option in options:
					var next_id = option.get("next", null)
					if next_id != null and trees.has(next_id):
						current_tree.add_child(trees[next_id])
		else:
			push_error("Failed to parse trees JSON: %s" % json.get_error_message())
	else:
		push_error("Trees file does not exist: %s" % file_path)
	
	return trees
