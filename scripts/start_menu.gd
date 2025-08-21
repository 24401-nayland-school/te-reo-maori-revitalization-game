extends Control

@onready var options := $Options

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_options_on_button_pressed() -> void:
	#options.show()
	pass

func _on_options_off_button_pressed() -> void:
	options.hide()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
