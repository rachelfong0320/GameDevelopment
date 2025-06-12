# scripts/globals/UIManager.gd - Global Singleton for Persistent UI
extends CanvasLayer

# References to persistent UI panels
var inventory_panel: Control
var time_panel: Control

# Scene references for instantiation
var inventory_panel_scene = preload("res://scenes/ui/inventory_panel.tscn")
var time_panel_scene = preload("res://scenes/ui/time_panel.tscn")

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

# Connect to time panel signals
func _on_time_up():
	print("Time's up! Handle game over logic here")
	# You can emit signals or call scene-specific functions here

func _on_time_warning(seconds_left: int):
	print("Time warning: ", seconds_left, " seconds left")
	# Handle warnings (play sounds, show notifications, etc.)
