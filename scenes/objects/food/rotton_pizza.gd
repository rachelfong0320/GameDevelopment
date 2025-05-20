extends Sprite2D

@onready var hurt_component: HurtComponent= $HurtComponent
@onready var damage_component: DamageComponent= $DamageComponent

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)
	material.set_shader_parameter("shake_intensity",0.5)
	
func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	
func on_max_damaged_reached()-> void:
	print("max damaged reached")
	queue_free()
