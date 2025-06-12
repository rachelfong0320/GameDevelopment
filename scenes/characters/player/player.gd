class_name Player
extends CharacterBody2D

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2

func _process(delta: float) -> void:
	if velocity ==Vector2.ZERO:
		$WalkFootsteps.stop()
	elif not $WalkFootsteps.playing:
		$WalkFootsteps.play()
	
