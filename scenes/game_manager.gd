extends Node2D

func _ready() -> void:
	var queue: Queue = Loader.load_queue("res://resources/json/queue.json")
	print("Queue size: ", queue.size())
	
	while not queue.is_empty():
		var item = queue.dequeue()
		print(item)
