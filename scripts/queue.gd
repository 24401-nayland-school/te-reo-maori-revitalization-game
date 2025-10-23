extends Node
class_name Queue

# Array of items in the Queue
var items: Array = []

# Add a QueueItem to the queue
func enqueue(item: QueueItem) -> void:
	items.append(item)

# Remove and return the first QueueItem
func dequeue() -> QueueItem:
	if is_empty():
		return null
	return items.pop_front()

# Peek at the first QueueItem without removing it
func peek() -> QueueItem:
	if is_empty():
		return null
	return items[0]

# Check if the queue is empty
func is_empty() -> bool:
	return items.size() == 0

# Get number of items in this queue
func size() -> int:
	return items.size()
