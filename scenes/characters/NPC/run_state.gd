extends NodeState

@export var npc: NPC
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 50

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = npc.velocity
	if direction.y <0:
		animated_sprite_2d.play("run_back")
	elif direction.x >0:
		animated_sprite_2d.play("run_right")
	elif direction.y >0:
		animated_sprite_2d.play("run_front")
	elif direction.x <0:
		animated_sprite_2d.play("run_left")
		
	#npc.velocity = direction * speed
	#npc.move_and_slide()


func _on_next_transitions() -> void:
	if !GameInputEvents.is_movement_input():
		transition.emit("Idle")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()
