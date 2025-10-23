extends Node

func _ready():
	print("TEST")
	test_tree_creation()
	test_tree_hierarchy()
	test_option_nodes()

func test_tree_creation():
	# Create root node
	var values = _TreeValues.new()
	values.id = "decision_1"
	values.title = "First Decision"
	values.description = "description"
	
	var root = TreeNode.new(values)
	
	print("Created root node: %s" % root.values.id)
	print("Is option node: %s (Expected: false)" % root.is_option_node)
	print("Children count: %d (Expected: 0)" % root.children.size())

func test_tree_hierarchy():
	# Create parent node
	var parent_values = _TreeValues.new()
	parent_values.id = "parent"
	parent_values.title = "Parent Decision"
	var parent = TreeNode.new(parent_values)
	
	# Create child nodes
	var child1_values = _TreeValues.new()
	child1_values.id = "child_1"
	child1_values.title = "Child 1"
	var child1 = TreeNode.new(child1_values)
	
	var child2_values = _TreeValues.new()
	child2_values.id = "child_2"
	child2_values.title = "Child 2"
	var child2 = TreeNode.new(child2_values)
	
	# Add children
	parent.add_child(child1)
	parent.add_child(child2)
	
	print("Parent has %d children (Expected: 2)" % parent.children.size())
	print("Child 1 ID: %s" % parent.children[0].values.id)
	print("Child 2 ID: %s" % parent.children[1].values.id)
	
	# Test remove child
	parent.remove_child(child1)
	print("After removing child 1: %d children (Expected: 1)" % parent.children.size())

func test_option_nodes():
	# Create decision node
	var decision_values = _TreeValues.new()
	decision_values.id = "decision"
	decision_values.title = "title"
	var decision = TreeNode.new(decision_values)
	
	# Create option node with impacts
	var option_values = OptionValues.new()
	option_values.id = "option_1"
	option_values.title = "title"
	option_values.public_support = -10
	option_values.language_strength = 20
	option_values.political_capital = -15
	option_values.budget = -25
	
	var option_node = TreeNode.new(null, option_values)
	
	print("Option node created")
	print("Is option node: %s (Expected: true)" % option_node.is_option_node)
	print("Has impacts: %s (Expected: true)" % option_node.option_values.has_impacts())
	
	# Create consequence node
	var consequence_values = _TreeValues.new()
	consequence_values.id = "consequence"
	consequence_values.title = "result"
	var consequence = TreeNode.new(consequence_values)
	
	# Link: decision -> option -> consequence
	option_node.add_child(consequence)
	decision.add_child(option_node)
	
	print("Tree structure:")
	print(decision._to_string())
