# Main Menu Script
extends Node2D

var level: int = 1

func _on_play_pressed() -> void:
	# Reset the game state before starting new game
	if UiManager:  # Access the AutoLoad singleton directly
		await UiManager.start_new_game()
		print("Game state reset from main menu")
	else:
		print("Warning: UIManager not found - make sure it's set up as AutoLoad")
	
	# Change to the game scene
	get_tree().change_scene_to_file("res://scenes/test/test_scene_class.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
