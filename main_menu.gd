extends Node2D

var level:int=1

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test/test_scene_class2.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
