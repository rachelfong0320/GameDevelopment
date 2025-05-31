# InventoryManager.gd
extends Node
signal inventory_updated(food_type: String, remaining_count: int)
# Use dictionary to track how many items to collect
var required_rotten_foods = {
	"rotten_apple": 4,
	"rotten_burger": 3,
	"rotten_coke": 2,
	"rotten_donut": 1,
	"rotten_icecream": 5,
}


func decrease_food_count(food_name: String) -> void:
	if required_rotten_foods.has(food_name):
		required_rotten_foods[food_name] -= 1
		required_rotten_foods[food_name] = max(0, required_rotten_foods[food_name])
		inventory_updated.emit()
