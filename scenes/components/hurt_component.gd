class_name HurtComponent
extends Area2D

@export var tool: DataTypes.Tools = DataTypes.Tools.rottenFood
@export var item_name: String = "rotten_apple"

signal hurt
signal fresh_food_collected
signal rotten_food_collected

func _on_area_entered(area: Area2D) -> void:
	var hit_component = area as HitComponent
	if not hit_component:
		return

	match tool:
		DataTypes.Tools.rottenFood:
			print("Food collected")

			# ↓↓↓ NEW: notify inventory manager ↓↓↓
			InventoryManager.decrease_food_count(get_parent().name)
			
			rotten_food_collected.emit()
			get_parent().queue_free()
