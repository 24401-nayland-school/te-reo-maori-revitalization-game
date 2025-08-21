extends Node
class_name Loader

static func load_queue(file_path: String) -> Queue:
	var queue: Queue = Queue.new()
	
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
				item.tree_id = tree_id
				queue.enqueue(item)
		else:
			push_error("Failed to parse JSON: %s" % json.get_error_message())
	else:
		push_error("File does not exist: %s" % file_path)
	
	return queue
