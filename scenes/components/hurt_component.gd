class_name HurtComponent
extends Area2D

@export var tool: DataTypes.Tools = DataTypes.Tools.None

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
			rotten_food_collected.emit()
			get_parent().queue_free()
		
		DataTypes.Tools.freshFood:
			print("Fresh food - damaging and emitting signal")
			hurt.emit(hit_component.hit_damage)
			fresh_food_collected.emit()
			get_parent().queue_free()
		
		_:
			print("Unhandled tool type:", tool)
