extends Node

@onready var cue_loader: CueLoader = CueLoader.new()

func _ready():
	cue_loader.load_cues("res://cue.json")
	
	# Access a cue by ID
	if cue_loader.cues.has("cue_1"):
		var cue = cue_loader.cues["cue_1"]
		print("Loaded Cue: %s - %s" % [cue.title, cue.description])
