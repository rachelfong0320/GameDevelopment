extends Node2D


func _on_mainmenu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
