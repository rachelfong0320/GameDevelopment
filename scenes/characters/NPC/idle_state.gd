extends NodeState

@export var npc:NPC
@export var animated_sprite_2d: AnimatedSprite2D

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:	
	#if npc.npc_direction == Vector2.UP:
		#animated_sprite_2d.play("idle_back")
	#elif npc.npc_direction == Vector2.RIGHT:
		#animated_sprite_2d.play("idle_right")
	#elif npc.npc_direction == Vector2.LEFT:
		#animated_sprite_2d.play("idle_left")
	#elif npc.npc_direction == Vector2.DOWN:
		#animated_sprite_2d.play("idle_front")
	#else:
		#animated_sprite_2d.play("idle_front")
	pass



func _on_next_transitions() -> void:
	GameInputEvents.movement_input()
	
	if GameInputEvents.is_movement_input():
		transition.emit("Run")
		
	if (npc.current_tool == DataTypes.Tools.freshFood || npc.current_tool == DataTypes.Tools.rottenFood) && GameInputEvents.use_tool():
		transition.emit("Taking")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()
