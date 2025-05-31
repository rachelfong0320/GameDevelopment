# scripts/globals/InventoryManager.gd - Global Singleton
extends Node

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

func collect_item(item_name: String) -> bool:
	if inventory.has(item_name) and inventory[item_name] > 0:
		inventory[item_name] -= 1
		inventory_changed.emit(item_name, inventory[item_name])
		print("Collected: ", item_name, " - Remaining: ", inventory[item_name])
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
