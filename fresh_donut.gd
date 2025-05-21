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
	# Call time manager or emit a higher-level signal
