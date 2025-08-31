extends Sprite2D
@onready var hurt_component = $HurtComponent
@onready var damage_component = $DamageComponent

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	hurt_component.fresh_food_collected.connect(on_fresh_food_collected)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)
	material.set_shader_parameter("shake_intensity",0.5)
	
func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	
func on_max_damaged_reached()-> void:
	print("max damaged reached")
	queue_free()


func on_fresh_food_collected():
	print("Time deduction triggered")
	
	var time_panels = get_tree().get_nodes_in_group("time_panel")
	if time_panels.size() > 0:
		var time_panel = time_panels[0]
		if time_panel.has_method("subtract_time"):
			time_panel.subtract_time(120.0)  # 2 minute penalty
