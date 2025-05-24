extends Node2D

func _ready():
	if scene_manager.player:
		add_child(scene_manager.player)
