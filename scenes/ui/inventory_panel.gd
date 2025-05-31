extends Control

@onready var labels = {
	"rotten_apple": $MarginContainer/VBoxContainer/Rotten_apple/appleLabel,
	"rotten_burger": $MarginContainer/VBoxContainer/Rotten_burger/burgerLabel,
	"rotten_coke": $MarginContainer/VBoxContainer/Rotten_coke/cokeLabel,
	"rotten_donut": $MarginContainer/VBoxContainer/Rotten_donut/donutLabel,
	"rotten_icecream": $MarginContainer/VBoxContainer/Rotten_icecream/icecreamLabel,
}

func _ready():
	InventoryManager.inventory_updated.connect(update_labels)
	update_labels()

func update_labels():
	for item in InventoryManager.required_rotten_foods.keys():
		if labels.has(item):
			labels[item].text = str(InventoryManager.required_rotten_foods[item])
