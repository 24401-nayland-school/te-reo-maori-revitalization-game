extends Control

@onready var progress_bar := $VBoxContainer/Footer/ProgressBar

var temp_time: float = 0

var queue: Queue = Loader.load_queue("res://resources/json/queue.json", "res://resources/json/trees.json")
var initial_queue_size: int = queue.size()

func _ready() -> void:
	progress_bar.value = 0

func _process(delta: float) -> void:
	temp_time += delta
	if not queue.is_empty() and temp_time >= 10:
		temp_time = 0
		var item: QueueItem = queue.dequeue()
		print(item)
		if item.tree != null:
			print(item.tree)
			print("Tree title: ", item.tree.values.title)
			print("Number of children: ", item.tree.children.size())
		progress_bar.value = (initial_queue_size - queue.size()) / float(initial_queue_size) * 100
