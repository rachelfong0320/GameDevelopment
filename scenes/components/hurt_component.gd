class_name HurtComponent
extends Area2D

@export var tool: DataTypes.Tools = DataTypes.Tools.None

signal hurt
signal fsktm_item_collected
signal food_collected

func _on_area_entered(area: Area2D) -> void:
	var hit_component = area as HitComponent
	
	if not hit_component:
		return
	
	match tool:
		DataTypes.Tools.Food:
			print("Food collected")
			food_collected.emit()
			get_parent().queue_free()
		
		DataTypes.Tools.fsktmItem:
			print("Fsktm item collected - damaging and emitting signal")
			hurt.emit(hit_component.hit_damage)
			fsktm_item_collected.emit()
			get_parent().queue_free()
		
		_:
			print("Unhandled tool type:", tool)
