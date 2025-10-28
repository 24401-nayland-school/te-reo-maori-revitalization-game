extends Control

# UI References
@onready var progress_bar := $MarginContainer/VBoxContainer/FooterContainer/VBoxContainer/ProgressBar
@onready var current_title := $MarginContainer/VBoxContainer/HeaderContainer/VBoxContainer/CurrentItemTitle
@onready var event_description := $MarginContainer/VBoxContainer/ContentContainer/HBoxContainer/EventSide/EventVBoxContainer/EventDescription
@onready var history_label := $MarginContainer/VBoxContainer/ContentContainer/HBoxContainer/EventSide/EventVBoxContainer/HistoryLabel
@onready var history_description := $MarginContainer/VBoxContainer/ContentContainer/HBoxContainer/EventSide/EventVBoxContainer/HistoryDescription
@onready var link_button := $MarginContainer/VBoxContainer/ContentContainer/HBoxContainer/EventSide/EventVBoxContainer/LinkButton
@onready var tree_title := $MarginContainer/VBoxContainer/ContentContainer/HBoxContainer/TreeSide/TreeVBoxContainer/TreeTitle
@onready var tree_description := $MarginContainer/VBoxContainer/ContentContainer/HBoxContainer/TreeSide/TreeVBoxContainer/TreeDescription
@onready var options_container := $MarginContainer/VBoxContainer/ContentContainer/HBoxContainer/TreeSide/TreeVBoxContainer/MarginContainer/OptionsVBoxContainer
@onready var next_button := $MarginContainer/VBoxContainer/FooterContainer/VBoxContainer/MarginContainer/NextButton
@onready var tree_side := $MarginContainer/VBoxContainer/ContentContainer/HBoxContainer/TreeSide

# Metrics labels
@onready var support_label := $MarginContainer/VBoxContainer/HeaderContainer/VBoxContainer/MetricsContainer/SupportLabel
@onready var language_label := $MarginContainer/VBoxContainer/HeaderContainer/VBoxContainer/MetricsContainer/LanguageLabel
@onready var capital_label := $MarginContainer/VBoxContainer/HeaderContainer/VBoxContainer/MetricsContainer/CapitalLabel
@onready var budget_label := $MarginContainer/VBoxContainer/HeaderContainer/VBoxContainer/MetricsContainer/BudgetLabel

# Game Data
var queue: Queue
var initial_queue_size: int
var current_item: QueueItem
var current_tree_node: TreeNode

# Game State Metrics
var public_support: int = 50
var language_strength: int = 50
var political_capital: int = 50
var budget: int = 0

const SHOW_ENGLISH_TOOLTIPS: bool = true  # Toggle for English tooltips

# Initialize everything
func _ready() -> void:
	# Load game data
	queue = Loader.load_queue("res://resources/json/queue.json", "res://resources/json/trees.json")
	initial_queue_size = queue.size()
	
	# Initializing UI
	progress_bar.value = 0
	next_button.disabled = true
	update_metrics_display()
	
	# Connecting to signals
	next_button.pressed.connect(_on_next_button_pressed)
	link_button.pressed.connect(_on_link_button_pressed)
	
	# Hiding history elements initially
	history_label.hide()
	history_description.hide()
	link_button.hide()
	
	# Start the game
	load_next_item()

# Load the next item from the queue
func load_next_item() -> void:
	
	if queue.is_empty():
		show_game_complete()
		return
	
	# Show tree side
	tree_side.show()
	
	# Get next queue item
	current_item = queue.dequeue()
	current_tree_node = current_item.tree
	
	# Update header with queue item title
	current_title.text = current_item.title
	if SHOW_ENGLISH_TOOLTIPS and current_item.title_en != "":
		current_title.tooltip_text = current_item.title_en
	
	# Show queue item description on the left
	event_description.clear()
	create_tooltip_text(event_description, current_item.description, current_item.description_en)
	
	# Add historical context if available
	if current_item.has_historical_context():
		history_label.show()
		history_description.show()
		
		# Set history label
		history_label.text = "Horopaki ō Mua:"
		if SHOW_ENGLISH_TOOLTIPS:
			history_label.tooltip_text = "Historical Context"
		
		# Build history description
		history_description.clear()
		if current_item.historical_year > 0:
			history_description.append_text("Year: %d\n" % current_item.historical_year)
			if SHOW_ENGLISH_TOOLTIPS:
				history_description.append_text("[hint=Year: %d][/hint]" % current_item.historical_year)
		
		if current_item.historical_significance != "":
			history_description.append_text(current_item.historical_significance)
		
		# Show link button if URL exists
		if current_item.historical_url != "":
			link_button.show()
			link_button.text = "Ako Atu"
			if SHOW_ENGLISH_TOOLTIPS:
				link_button.tooltip_text = "Learn More"
			link_button.uri = current_item.historical_url
		else:
			link_button.hide()
	else:
		pass
		# Hide history section if no context
		history_label.hide()
		history_description.hide()
		link_button.hide()
	
	# Disable next button until tree is completed
	next_button.disabled = true
	
	# Load tree content on the right if available
	if current_tree_node != null:
		display_tree_node(current_tree_node)
	else:
		# No tree associated
		tree_title.text = "Kāore he Whakapānga"
		tree_description.clear()
		tree_description.append_text("Kāore he kōwhiringa mō tēnei kaupapa.")
		if SHOW_ENGLISH_TOOLTIPS:
			tree_title.tooltip_text = "No Interaction"
		clear_options()
		next_button.disabled = false
	
	update_progress()

# Display tree node from a tree node structure
func display_tree_node(node: TreeNode) -> void:
	if node == null or node.values == null:
		return
	
	# Show tree node title and description on the right
	tree_title.text = node.values.title
	if SHOW_ENGLISH_TOOLTIPS and node.values.title_en != "":
		tree_title.tooltip_text = node.values.title_en
	
	tree_description.clear()
	create_tooltip_text(tree_description, node.values.description, node.values.description_en)
	
	# Display decision node with options
	display_decision_node(node)

# Display a decision node (has options to choose from)
func display_decision_node(node: TreeNode) -> void:
	# Clear previous options
	clear_options()
	
	# Create option buttons for children
	if node.children.size() > 0:
		for child in node.children:
			# Check if this child is an option node
			if not child.is_option_node or child.option_values == null:
				continue
			
			var button: Button = Button.new()
			button.text = child.option_values.title
			button.custom_minimum_size = Vector2(0, 50)
			
			# Create detailed English tooltip with impacts
			if SHOW_ENGLISH_TOOLTIPS and child.option_values.title_en != "":
				var tooltip_text = child.option_values.title_en
				
				# Add impact preview to tooltip
				if child.option_values.has_impacts():
					tooltip_text += "\n\nImpacts:"
					if child.option_values.public_support != 0:
						tooltip_text += "\nPublic Support: %+d" % child.option_values.public_support
					if child.option_values.language_strength != 0:
						tooltip_text += "\nLanguage Strength: %+d" % child.option_values.language_strength
					if child.option_values.political_capital != 0:
						tooltip_text += "\nPolitical Capital: %+d" % child.option_values.political_capital
					if child.option_values.budget != 0:
						tooltip_text += "\nBudget: %+d million" % child.option_values.budget
				
				button.tooltip_text = tooltip_text
			
			# Connect button to handle selection
			button.pressed.connect(func(): handle_option_selected(child))
			
			options_container.add_child(button)
	else:
		# No children, enable next button
		next_button.disabled = false
		print(null)

# Navigate to the selected child node
func handle_option_selected(selected_node: TreeNode) -> void:
	# Apply impacts from this option
	if selected_node.is_option_node and selected_node.option_values != null:
		if selected_node.option_values.has_impacts():
			apply_impacts_from_option(selected_node.option_values)
	
	# Check if it has a child (the next tree)
	if selected_node.children.size() > 0:
		current_tree_node = selected_node.children[0]
		display_tree_node(current_tree_node)
	else:
		# No next tree, this option ends the branch
		# Hide the tree side panel since user already knows what happened
		tree_side.hide()
		clear_options()
		next_button.disabled = false

# Create hoverable text with tooltip in RichTextLabel
func create_tooltip_text(rich_label: RichTextLabel, maori_text: String, english_text: String) -> void:
	if not SHOW_ENGLISH_TOOLTIPS or english_text == "":
		# No tooltip needed, just append the text
		rich_label.append_text(maori_text)
		return
	
	# Split text into sentences for better tooltip coverage
	var sentences = maori_text.split(".")
	var english_sentences = english_text.split(".")
	
	for i in range(sentences.size()):
		var sentence = sentences[i].strip_edges()
		if sentence == "":
			continue
		
		# Get corresponding English sentence
		var english_sentence = ""
		if i < english_sentences.size():
			english_sentence = english_sentences[i].strip_edges()
		
		# Create a hint tooltip by using BBCode hint tag
		if english_sentence != "":
			rich_label.append_text("[hint=%s]%s[/hint]" % [english_sentence, sentence])
		else:
			rich_label.append_text(sentence)
		
		# Add period back if not last sentence
		if i < sentences.size() - 1:
			rich_label.append_text(". ")

# Apply impacts from option values to game state
func apply_impacts_from_option(option_vals: OptionValues) -> void:
	public_support += option_vals.public_support
	language_strength += option_vals.language_strength
	political_capital += option_vals.political_capital
	budget += option_vals.budget
	
	# Clamp values to reasonable ranges
	public_support = clampi(public_support, 0, 100)
	language_strength = clampi(language_strength, 0, 100)
	political_capital = clampi(political_capital, 0, 100)
	
	# Update display
	update_metrics_display()
	
	# Check for game over conditions
	check_game_over()

# Update metrics display
func update_metrics_display() -> void:
	if support_label:
		support_label.text = "Tautoko Hapori: %d" % public_support
		if SHOW_ENGLISH_TOOLTIPS:
			support_label.tooltip_text = "Public Support: %d. Below 10%% = Game Over" % public_support
	if language_label:
		language_label.text = "Kaha o te Reo: %d" % language_strength
		if SHOW_ENGLISH_TOOLTIPS:
			language_label.tooltip_text = "Language Strength: %d. Reach 95%% to win!" % language_strength
	if capital_label:
		capital_label.text = "Pūtea Tōrangapū: %d" % political_capital
		if SHOW_ENGLISH_TOOLTIPS:
			capital_label.tooltip_text = "Political Capital: %d. Resources for legislation." % political_capital
	if budget_label:
		budget_label.text = "Pūtea: %d miriona" % budget
		if SHOW_ENGLISH_TOOLTIPS:
			budget_label.tooltip_text = "Budget: %d million spent (cumulative)" % budget

# Check for game over conditions
func check_game_over() -> void:
	if public_support <= 10:
		show_game_over(false)  # Lost
	elif language_strength >= 95:
		show_game_over(true)  # Won

# Show game over screen
func show_game_over(is_victory: bool) -> void:
	current_title.text = "Kua Mutu te Kēmu"
	if SHOW_ENGLISH_TOOLTIPS:
		current_title.tooltip_text = "Game Over"
	
	event_description.clear()
	
	# Display appropriate message based on victory or defeat
	if is_victory:
		create_tooltip_text(event_description, 
			"Kua kaha te Reo Māori! Kua tutuki koe i te whakaoranga tino!", 
			"Te Reo Māori is strong! You have achieved full revitalization!")
	else:
		create_tooltip_text(event_description, 
			"Kua ngaro te tautoko hapori, kua pōtingia koe ki waho!", 
			"Public support has been lost, you have been voted out!")
	
	# Hide history section
	history_label.hide()
	history_description.hide()
	link_button.hide()
	
	# Hide tree side
	tree_side.hide()
	
	clear_options()
	next_button.text = "Hoki ki te Tahua"
	if SHOW_ENGLISH_TOOLTIPS:
		next_button.tooltip_text = "Return to Menu"
	next_button.disabled = false

# Remove all option buttons
func clear_options() -> void:
	for child in options_container.get_children():
		child.queue_free()

# Update progress bar value
func update_progress() -> void:
	var items_completed = initial_queue_size - queue.size()
	var progress_value = (items_completed / float(initial_queue_size)) * 100
	progress_bar.value = progress_value

# Show that the game is completed
func show_game_complete() -> void:
	current_title.text = "Kua Oti te Kēmu!"
	if SHOW_ENGLISH_TOOLTIPS:
		current_title.tooltip_text = "Game Complete!"
	
	# Show final statistics
	event_description.clear()
	event_description.append_text("Kia ora! Kua oti ngā kaupapa katoa.\n\n")
	event_description.append_text("Ngā Tatauranga Whakamutunga:\n")
	event_description.append_text("Tautoko Hapori: %d\n" % public_support)
	event_description.append_text("Kaha o te Reo: %d\n" % language_strength)
	event_description.append_text("Pūtea Tōrangapū: %d\n" % political_capital)
	event_description.append_text("Pūtea: %d miriona\n\n" % budget)
	
	# Determine ending
	if language_strength >= 80:
		event_description.append_text("Wikitoria! Kei te kaha te Reo Māori puta noa i Aotearoa!")
	elif language_strength >= 60:
		event_description.append_text("Angitū! He kaha te noho o te Reo Māori.")
	elif language_strength >= 40:
		event_description.append_text("Kua Whai Hua. Ētahi painga, engari me mahi tonu.")
	else:
		event_description.append_text("He Whawhai. Kei te tū tonu ngā wero mō te Reo Māori.")
	
	# Hide history section
	history_label.hide()
	history_description.hide()
	link_button.hide()
	
	# Hide tree side
	tree_side.hide()
	
	clear_options()
	next_button.text = "Hoki ki te Tahua"
	if SHOW_ENGLISH_TOOLTIPS:
		next_button.tooltip_text = "Return to Menu"
	next_button.disabled = false

# Handle link button pressed
func _on_link_button_pressed() -> void:
	if current_item and current_item.historical_url != "":
		OS.shell_open(current_item.historical_url)

# Handle event if next button is pressed
func _on_next_button_pressed() -> void:
	if next_button.text == "Hoki ki te Tahua":
		# Game is complete or game over, return to menu
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	else:
		# Load next item
		load_next_item()
