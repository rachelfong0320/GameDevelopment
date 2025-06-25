# scripts/globals/InventoryManager.gd - Global Singleton
extends Node

# Remove direct time_panel reference - let UIManager handle UI
var inventory: Dictionary = {
	"rotten_apple": 5,
	"rotten_burger": 4,
	"rotten_coke": 4,
	"rotten_donut": 7,
	"rotten_icecream": 8
}

signal inventory_changed(item_name: String, new_count: int)

func _ready():
	# Make this node persistent across scenes
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	
	# Wait for UIManager to be ready
	await get_tree().process_frame
	
	print("InventoryManager initialized")

func collect_item(item_name: String) -> bool:
	if inventory.has(item_name) and inventory[item_name] > 0:
		inventory[item_name] -= 1
		inventory_changed.emit(item_name, inventory[item_name])
		print("Collected: ", item_name, " - Remaining: ", inventory[item_name])
		
		# Check if all items collected and notify UIManager
		if _check_all_items_collected():
			print("All rotten items collected! Game should end in victory!")
			# Let UIManager handle the win condition - try multiple ways to access it
			if get_tree().has_group("ui_manager"):
				var ui_manager = get_tree().get_first_node_in_group("ui_manager")
				ui_manager.trigger_win()
			elif has_node("/root/UIManager"):
				get_node("/root/UIManager").trigger_win()
			else:
				print("UIManager not found - make sure it's set up as AutoLoad")
		
		return true
	else:
		print("Cannot collect ", item_name, " - not available or count is 0")
		return false

func get_item_count(item_name: String) -> int:
	return inventory.get(item_name, 0)

func get_all_inventory() -> Dictionary:
	return inventory.duplicate()

func reset_inventory():
	inventory = {
		"rotten_apple": 5,
		"rotten_burger": 4,
		"rotten_coke": 4,
		"rotten_donut": 7,
		"rotten_icecream": 8
	}
	# Emit signals for all items to update UI
	for item_name in inventory.keys():
		inventory_changed.emit(item_name, inventory[item_name])
	print("Inventory reset to default values")

# Helper function to check if all items are collected
func _check_all_items_collected() -> bool:
	var total_items = 0
	for item_count in inventory.values():
		total_items += item_count
	return total_items == 0

# Get total remaining items (useful for UI display)
func get_total_remaining_items() -> int:
	var total = 0
	for item_count in inventory.values():
		total += item_count
	return total

# Check if specific item exists and has quantity > 0
func has_item(item_name: String) -> bool:
	return inventory.has(item_name) and inventory[item_name] > 0

# Add item back to inventory (if needed for gameplay mechanics)
func add_item(item_name: String, quantity: int = 1):
	if inventory.has(item_name):
		inventory[item_name] += quantity
	else:
		inventory[item_name] = quantity
	inventory_changed.emit(item_name, inventory[item_name])
	print("Added: ", quantity, "x ", item_name, " - New count: ", inventory[item_name])
