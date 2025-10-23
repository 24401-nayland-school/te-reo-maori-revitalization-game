extends Node

func _ready():
	print("TEST")
	test_basic()
	test_empty_queue()
	test_multiple_items()

func test_basic():
	var q = Queue.new()
	
	# Create test items
	var item1 = QueueItem.new()
	item1.id = "test_1"
	item1.title = "First Event"
	
	var item2 = QueueItem.new()
	item2.id = "test_2"
	item2.title = "Second Event"
	
	# Test enqueue
	q.enqueue(item1)
	q.enqueue(item2)
	print("Enqueued 2 items")
	print("Queue size: %d (Expected: 2)" % q.size())
	
	# Test peek
	var peeked = q.peek()
	print("Peeked item: %s (Expected: test_1)" % peeked.id)
	print("Queue size after peek: %d (Expected: 2)" % q.size())
	
	# Test dequeue
	var dequeued = q.dequeue()
	print("Dequeued item: %s (Expected: test_1)" % dequeued.id)
	print("Queue size after dequeue: %d (Expected: 1)" % q.size())

func test_empty_queue():
	var q = Queue.new()
	
	print("Is empty: %s (Expected: true)" % q.is_empty())
	print("Size: %d (Expected: 0)" % q.size())
	
	var result = q.dequeue()
	print("Dequeue from empty: %s (Expected: null)" % result)
	
	var peek_result = q.peek()
	print("Peek at empty: %s (Expected: null)" % peek_result)

func test_multiple_items():
	var q = Queue.new()
	
	for i in range(5):
		var item = QueueItem.new()
		item.id = str(i)
		item.title = "Event %d" % i
		q.enqueue(item)
	
	print("Enqueued 5 items")
	print("Queue size: %d (Expected: 5)" % q.size())
	
	# Dequeue and verify order
	print("Dequeuing in order:")
	for i in range(5):
		var item = q.dequeue()
		print("Item %d: %s (Expected: event_%d)" % [i, item.id, i])
	
	print("Final queue size: %d (Expected: 0)" % q.size())
