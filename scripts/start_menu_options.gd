extends Control

@onready var option_pages := $OptionsMarginContainer/VBoxContainer/OptionPages

func _on_tab_selected(tab: int) -> void:
	for i in option_pages.get_child_count():
		option_pages.get_child(i).visible = (i == tab)
