# Alternative InventoryPanel.gd - Simpler approach without singleton
extends Control

# Inventory data stored locally
var inventory: Dictionary = {
	"rotten_apple": 5,
	"rotten_burger": 4,
	"rotten_coke": 4,
	"rotten_donut": 7,
	"rotten_icecream": 8
}

# References to your labels - UPDATE THESE PATHS TO MATCH YOUR EXACT STRUCTURE
@onready var apple_label = $"MarginContainer/VBoxContainer/Rotten_apple/appleLabel"
@onready var burger_label = $"MarginContainer/VBoxContainer/Rotten_burger/burgerLabel" 
@onready var coke_label = $"MarginContainer/VBoxContainer/Rotten_coke/cokeLabel"
@onready var donut_label = $"MarginContainer/VBoxContainer/Rotten_donut/donutLabel"
@onready var icecream_label = $"MarginContainer/VBoxContainer/Rotten_icecream/icecreamLabel"

func _ready():
	# Add this node to a group so food items can find it
	add_to_group("inventory_ui")
	print("InventoryPanel added to 'inventory_ui' group")
	
	# Initialize UI
	_update_all_labels()
	
	# Debug: Print node structure to help fix label paths
	print("=== InventoryPanel structure ===")
	_print_node_tree(self, 0)

func _print_node_tree(node: Node, indent: int):
	var indent_str = ""
	for i in indent:
		indent_str += "  "
	print(indent_str + "- " + node.name + " (" + node.get_class() + ")")
	
	for child in node.get_children():
		_print_node_tree(child, indent + 1)

func collect_item(item_name: String) -> bool:
	if inventory.has(item_name) and inventory[item_name] > 0:
		inventory[item_name] -= 1
		_update_label_for_item(item_name)
		print("Collected: ", item_name, " - Remaining: ", inventory[item_name])
		return true
	else:
		print("Cannot collect ", item_name, " - not available or count is 0")
		return false

func _update_label_for_item(item_name: String):
	match item_name:
		"rotten_apple":
			if apple_label:
				apple_label.text = str(inventory[item_name])
		"rotten_burger":
			if burger_label:
				burger_label.text = str(inventory[item_name])
		"rotten_coke":
			if coke_label:
				coke_label.text = str(inventory[item_name])
		"rotten_donut":
			if donut_label:
				donut_label.text = str(inventory[item_name])
		"rotten_icecream":
			if icecream_label:
				icecream_label.text = str(inventory[item_name])

func _update_all_labels():
	# Try to find labels using multiple methods
	if not apple_label:
		apple_label = find_child("appleLabel", true, false)
	if not burger_label:
		burger_label = find_child("burgerLabel", true, false)
	if not coke_label:
		coke_label = find_child("cokeLabel", true, false)
	if not donut_label:
		donut_label = find_child("donutLabel", true, false)
	if not icecream_label:
		icecream_label = find_child("icecreamLabel", true, false)
	
	# Update all labels
	if apple_label:
		apple_label.text = str(inventory.get("rotten_apple", 0))
	else:
		print("WARNING: apple_label not found")
		
	if burger_label:
		burger_label.text = str(inventory.get("rotten_burger", 0))
	else:
		print("WARNING: burger_label not found")
		
	if coke_label:
		coke_label.text = str(inventory.get("rotten_coke", 0))
	else:
		print("WARNING: coke_label not found")
		
	if donut_label:
		donut_label.text = str(inventory.get("rotten_donut", 0))
	else:
		print("WARNING: donut_label not found")
		
	if icecream_label:
		icecream_label.text = str(inventory.get("rotten_icecream", 0))
	else:
		print("WARNING: icecream_label not found")
