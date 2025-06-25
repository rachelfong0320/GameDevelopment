# Simple HurtComponent.gd - Without singleton dependency
class_name HurtComponent
extends Area2D

@export var tool: DataTypes.Tools = DataTypes.Tools.None
@export var item_name: String = ""

signal hurt
signal fresh_food_collected
signal rotten_food_collected

func _ready():
	# Connect the area_entered signal
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	
	# Auto-set item_name based on parent's scene filename if not manually set
	if item_name.is_empty():
		var parent_scene_path = get_parent().scene_file_path
		if parent_scene_path:
			var scene_name = parent_scene_path.get_file().get_basename()
			# Fix naming inconsistencies
			match scene_name:
				"rotten_ice_cream":
					item_name = "rotten_icecream"
				_:
					item_name = scene_name
			print("Auto-detected item name: ", item_name)
		else:
			# Fallback: try to get from parent node name
			item_name = get_parent().name.to_lower()
			print("Using parent name as item_name: ", item_name)

func _on_area_entered(area: Area2D) -> void:
	var hit_component = area as HitComponent
	
	if not hit_component:
		print("No HitComponent found on: ", area.name)
		return
	
	print("Tool type: ", tool, " (", DataTypes.Tools.keys()[tool] if tool < DataTypes.Tools.size() else "UNKNOWN", ")")
	
	match tool:
		DataTypes.Tools.rottenFood:
			print("Processing rotten food: ", item_name)
			
			# Find the inventory UI using groups
			var inventory_panels = get_tree().get_nodes_in_group("inventory_ui")
			if inventory_panels.size() > 0:
				var inventory_panel = inventory_panels[0]
				print("Found inventory panel: ", inventory_panel.name)
				if inventory_panel.has_method("collect_item"):
					if inventory_panel.collect_item(item_name):
						print("Successfully collected: ", item_name)
						rotten_food_collected.emit()
						get_parent().queue_free()
					else:
						print("Cannot collect ", item_name, " - inventory full or not needed")
				else:
					print("ERROR: inventory_panel doesn't have collect_item method")
			else:
				print("ERROR: No inventory UI found in 'inventory_ui' group")
		
		DataTypes.Tools.freshFood:
			print("Processing fresh food - damaging and emitting signal")
			hurt.emit(hit_component.hit_damage)
			fresh_food_collected.emit()
			get_parent().queue_free()
		
		DataTypes.Tools.None:
			print("Tool type is None - check your DataTypes.Tools enum setup")
		
		_:
			print("Unhandled tool type: ", tool, " - Available types: ", DataTypes.Tools.keys())
