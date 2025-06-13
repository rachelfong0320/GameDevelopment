# scripts/globals/UIManager.gd - Updated with scene transition logic
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

func _ready():
	# Set process mode to always so it persists across scene changes
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	
	# Create and add persistent UI panels
	_create_persistent_panels()
	
	print("UIManager initialized with persistent panels")

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
	
	# Hide UI panels immediately
	_hide_ui_panels()
	
	# Small delay to show the final state
	await get_tree().create_timer(1.0).timeout
	
	# Change to win scene
	get_tree().change_scene_to_file(win_scene_path)

func _on_game_lost():
	print("Game Lost! Transitioning to lose scene...")
	pause_timer()  # Stop the timer
	
	# Hide UI panels immediately
	_hide_ui_panels()
	
	# Small delay to show the final state
	await get_tree().create_timer(1.0).timeout
	
	# Change to lose scene
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
	if inventory_panel and inventory_panel.has_method("reset_inventory"):
		inventory_panel.reset_inventory()
	
	if time_panel and time_panel.has_method("stop_timer"):
		time_panel.stop_timer()
		time_panel.start_timer()

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

# Function to show panels when returning to game (useful for restart)
func show_game_ui():
	_show_ui_panels()

# Function to hide panels when in menu/win/lose scenes
func hide_game_ui():
	_hide_ui_panels()
