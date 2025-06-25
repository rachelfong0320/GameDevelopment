# scripts/globals/UIManager.gd - Updated with proper scene-based UI visibility
extends CanvasLayer

# References to persistent UI panels
var inventory_panel: Control
var time_panel: Control

# Scene references for instantiation
var inventory_panel_scene = preload("res://scenes/ui/inventory_panel.tscn")
var time_panel_scene = preload("res://scenes/ui/time_panel.tscn")

# Win/Lose scene paths - UPDATE THESE TO MATCH YOUR ACTUAL PATHS
var win_scene_path = "res://scenes/win_scene.tscn"
var lose_scene_path = "res://scenes/lose_scene.tscn"

# Define which scenes should show the game UI
var game_scenes = [
	"res://scenes/test/test_scene_class.tscn",
	"res://scenes/test/test_scene_class2.tscn"
	# Add more game scenes here as needed
]

# Track if panels have been created
var panels_created = false

func _ready():
	# Set process mode to always so it persists across scene changes
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	
	# Connect to scene tree changes to control UI visibility
	get_tree().node_added.connect(_on_scene_changed)
	
	# Check if current scene needs UI
	_check_and_manage_ui()
	
	print("UIManager initialized")

func _on_scene_changed(node: Node):
	"""Called when the scene tree changes"""
	# Only react to main scene changes
	if node == get_tree().current_scene:
		_check_and_manage_ui()

# Track if this is the first time entering a game scene in this session
var game_started = false

func _check_and_manage_ui():
	"""Check current scene and show/hide UI accordingly"""
	var current_scene_path = get_tree().current_scene.scene_file_path
	
	if _is_game_scene(current_scene_path):
		_ensure_panels_created()
		_show_ui_panels()
		
		# Auto-reset when first entering a game scene
		if not game_started:
			reset_game()
			game_started = true
		else:
			# Just refresh UI panels with current data
			_refresh_ui_panels()
		
		print("Game scene detected: ", current_scene_path, " - UI shown")
	else:
		_hide_ui_panels()
		print("Non-game scene detected: ", current_scene_path, " - UI hidden")

# Function to refresh UI panels with current data
func _refresh_ui_panels():
	"""Refresh UI panels with current data from managers"""
	if not panels_created:
		return
		
	# Refresh inventory panel
	if inventory_panel and has_node("/root/InventoryManager"):
		var inventory_manager = get_node("/root/InventoryManager")
		
		# If inventory panel has a refresh method, call it
		if inventory_panel.has_method("refresh_inventory"):
			inventory_panel.refresh_inventory()
		# Otherwise, try to reset and update with current data
		elif inventory_panel.has_method("reset_inventory"):
			inventory_panel.reset_inventory()
			# Update with current inventory data
			var current_inventory = inventory_manager.get_all_inventory()
			for item_name in current_inventory.keys():
				if inventory_panel.has_method("update_item_count"):
					inventory_panel.update_item_count(item_name, current_inventory[item_name])
	
	print("UI panels refreshed with current data")

func _is_game_scene(scene_path: String) -> bool:
	"""Check if the given scene path is a game scene that needs UI"""
	return scene_path in game_scenes

func _ensure_panels_created():
	"""Create panels if they haven't been created yet"""
	if not panels_created:
		_create_persistent_panels()
		panels_created = true

func _create_persistent_panels():
	inventory_panel = inventory_panel_scene.instantiate()
	inventory_panel.name = "PersistentInventoryPanel"
	add_child(inventory_panel)

	time_panel = time_panel_scene.instantiate()
	time_panel.name = "PersistentTimePanel"
	add_child(time_panel)

	# Connect time panel signals
	if time_panel.has_signal("game_won"):
		time_panel.game_won.connect(_on_game_won)
	if time_panel.has_signal("game_lost"):
		time_panel.game_lost.connect(_on_game_lost)
	if time_panel.has_signal("time_up"):
		time_panel.time_up.connect(_on_time_up)
	if time_panel.has_signal("time_warning"):
		time_panel.time_warning.connect(_on_time_warning)

	# Wait for the next frame to ensure screen size is available
	await get_tree().process_frame

	# Set position relative to viewport size
	var screen_size = get_viewport().get_visible_rect().size

	# 🟩 Left-center for inventory
	inventory_panel.position = Vector2(10, screen_size.y / 2.0 - inventory_panel.size.y / 2.0)

	# 🟦 Upper-right for time panel
	time_panel.position = Vector2(10, 10)

	print("Persistent UI panels created and positioned")

func get_inventory_panel() -> Control:
	return inventory_panel

func get_time_panel() -> Control:
	return time_panel

# Convenience functions to access panel functionality
func collect_item(item_name: String) -> bool:
	if inventory_panel and inventory_panel.has_method("collect_item"):
		return inventory_panel.collect_item(item_name)
	return false

func start_timer():
	if time_panel and time_panel.has_method("start_timer"):
		time_panel.start_timer()

func pause_timer():
	if time_panel and time_panel.has_method("pause_timer"):
		time_panel.pause_timer()

func stop_timer():
	if time_panel and time_panel.has_method("stop_timer"):
		time_panel.stop_timer()

func add_time(seconds: float):
	if time_panel and time_panel.has_method("add_time"):
		time_panel.add_time(seconds)

func subtract_time(seconds: float):
	if time_panel and time_panel.has_method("subtract_time"):
		time_panel.subtract_time(seconds)

# Signal handlers for game state changes
func _on_game_won():
	print("Game Won! Transitioning to win scene...")
	pause_timer()  # Stop the timer
	
	# Small delay to show the final state
	await get_tree().create_timer(1.0).timeout
	
	# Change to win scene (UI will be hidden automatically)
	get_tree().change_scene_to_file(win_scene_path)

func _on_game_lost():
	print("Game Lost! Transitioning to lose scene...")
	pause_timer()  # Stop the timer
	
	# Small delay to show the final state
	await get_tree().create_timer(1.0).timeout
	
	# Change to lose scene (UI will be hidden automatically)
	get_tree().change_scene_to_file(lose_scene_path)

func _on_time_up():
	print("Time's up! Checking game state...")
	# The time panel will handle checking if it's a win or loss

func _on_time_warning(seconds_left: int):
	print("Time warning: ", seconds_left, " seconds left")
	# Handle warnings (play sounds, show notifications, etc.)
	# You could add visual/audio feedback here

# Helper function to check if all items are collected
func check_all_items_collected() -> bool:
	if inventory_panel and inventory_panel.has_method("get_all_inventory"):
		var inventory = inventory_panel.get_all_inventory()
		var total_items = 0
		for item_count in inventory.values():
			total_items += item_count
		return total_items == 0
	return false

# Function to manually trigger win/lose (for testing or special cases)
func trigger_win():
	_on_game_won()

func trigger_lose():
	_on_game_lost()

# Function to reset game state (useful for restarting)
func reset_game():
	print("Resetting game state...")
	
	# Reset InventoryManager data first
	if has_node("/root/InventoryManager"):
		get_node("/root/InventoryManager").reset_inventory()
		print("InventoryManager reset")
	
	# Wait a frame to ensure the reset is processed
	await get_tree().process_frame
	
	# Reset UI panels AFTER InventoryManager is reset
	if inventory_panel and inventory_panel.has_method("reset_inventory"):
		inventory_panel.reset_inventory()
		print("Inventory panel reset")
	
	if time_panel:
		if time_panel.has_method("stop_timer"):
			time_panel.stop_timer()
		if time_panel.has_method("reset_timer"):
			time_panel.reset_timer()
			print("Timer reset")
		elif time_panel.has_method("start_timer"):
			time_panel.start_timer()
			print("Timer started")
	
	# Force refresh UI with the reset data
	_refresh_ui_panels()
	
	print("Game state reset complete")

# Function to manually start a new game (resets the flag)
func start_new_game():
	print("Starting new game...")
	game_started = false  # Reset the flag so game will be reset on next game scene
	reset_game()
	
	# Ensure UI is shown if we're in a game scene
	_check_and_manage_ui()
	
	# Start the timer
	start_timer()
	
	print("New game started")

# Function to hide UI panels
func _hide_ui_panels():
	"""Hide the persistent UI panels"""
	if inventory_panel:
		inventory_panel.visible = false
		print("Inventory panel hidden")
	
	if time_panel:
		time_panel.visible = false
		print("Time panel hidden")

# Function to show UI panels
func _show_ui_panels():
	"""Show the persistent UI panels"""
	if inventory_panel:
		inventory_panel.visible = true
		print("Inventory panel shown")
	
	if time_panel:
		time_panel.visible = true
		print("Time panel shown")

# Public functions for manual control (if needed)
func show_game_ui():
	"""Manually show game UI"""
	_ensure_panels_created()
	_show_ui_panels()

func hide_game_ui():
	"""Manually hide game UI"""
	_hide_ui_panels()

# Function to add new game scenes to the list
func add_game_scene(scene_path: String):
	"""Add a new scene path to the list of game scenes"""
	if scene_path not in game_scenes:
		game_scenes.append(scene_path)
		print("Added game scene: ", scene_path)
