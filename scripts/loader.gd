extends Node
class_name Loader

# Load Queue from a queue and trees file path
static func load_queue(file_path: String, trees_file_path: String) -> Queue:
	var queue: Queue = Queue.new()
	
	# Load all trees from the JSON file
	var trees: Dictionary = load_trees(trees_file_path)
	
	# Check if the queue JSON file exists
	if FileAccess.file_exists(file_path):
		# Open the queue JSON file
		var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var json_text: String = file.get_as_text()
		file.close()
		
		# Parse the JSON text
		var json: JSON = JSON.new()
		var error: Error = json.parse(json_text)
		
		# Check if no error occured
		if error == OK:
			var data: Variant = json.data
			for q_data in data:
				# Create a new item in the queue
				var item: QueueItem = QueueItem.new()
				item.id = q_data.get("id", "")
				item.title = q_data.get("title", "")
				item.title_en = q_data.get("title_en", "")
				item.description = q_data.get("description", "")
				item.description_en = q_data.get("description_en", "")
				item.category = q_data.get("category", "")
				
				# Load historical context if it exists
				var historical = q_data.get("historical_context", null)
				if historical != null and typeof(historical) == TYPE_DICTIONARY:
					item.historical_year = historical.get("year", 0)
					item.historical_significance = historical.get("significance", "")
					item.historical_url = historical.get("learn_more_url", "")
				
				# Get the tree_id associated with this queue item
				var tree_id = q_data.get("tree_id", "")
				if tree_id == null:
					tree_id = ""
				
				# Assign the right TreeNode if it exists
				if tree_id != "" and trees.has(tree_id):
					item.tree = trees[tree_id]
				else:
					item.tree = null
				
				# Enqueue item to the queue
				queue.enqueue(item)
		else:
			# Log error if the JSON parsing failed
			push_error("Failed to parse JSON: %s" % json.get_error_message())
	else:
		# Log error if file does not exist
		push_error("File does not exist: %s" % file_path)
	
	# Return the final queue
	return queue

# Load the trees from the JSON file
static func load_trees(file_path: String) -> Dictionary:
	var trees: Dictionary = {}
	
	# Check if the tree JSON file exists
	if FileAccess.file_exists(file_path):
		# Open the tree JSON file
		var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var json_text: String = file.get_as_text()
		file.close()
		
		# Parse the JSON file
		var json: JSON = JSON.new()
		var error: Error = json.parse(json_text)
		if error == OK:
			var data: Variant = json.data
			
			# Create all tree nodes
			for tree_data in data:
				var tree_node: TreeNode = TreeNode.new()
				var values: _TreeValues = _TreeValues.new()
				
				values.id = tree_data.get("id", "")
				values.title = tree_data.get("title", "")
				values.title_en = tree_data.get("title_en", "")
				values.description = tree_data.get("description", "")
				values.description_en = tree_data.get("description_en", "")
				
				tree_node.values = values
				trees[values.id] = tree_node
			
			# Link children based on options
			for tree_data in data:
				var tree_id: String = tree_data.get("id", "")
				var current_tree: TreeNode = trees[tree_id]
				var options: Array = tree_data.get("options", [])
				
				for option in options:
					# Create option values
					var option_values: OptionValues = OptionValues.new()
					
					# Store the option text
					option_values.id = tree_id + "_option_" + str(current_tree.children.size())
					option_values.title = option.get("title", "")
					option_values.title_en = option.get("title_en", "")
					
					# Load impacts from the option
					var impacts = option.get("impacts", null)
					if impacts != null and typeof(impacts) == TYPE_DICTIONARY:
						option_values.public_support = impacts.get("public_support", 0)
						option_values.language_strength = impacts.get("language_strength", 0)
						option_values.political_capital = impacts.get("political_capital", 0)
						option_values.budget = impacts.get("budget", 0)
					
					# Create a child node for this option (option node)
					var option_node: TreeNode = TreeNode.new(null, option_values)
					
					# Link to next tree if it exists
					var next_id = option.get("next", null)
					if next_id != null and next_id != "" and trees.has(next_id):
						option_node.add_child(trees[next_id])
					
					# Add this option as a child of the current tree
					current_tree.add_child(option_node)
		else:
			# Log error if JSON parsing failed
			push_error("Failed to parse trees JSON: %s" % json.get_error_message())
	else:
		# Log error if tree file does not exist
		push_error("Trees file does not exist: %s" % file_path)
	
	# Return the final tree dictionary
	return trees
