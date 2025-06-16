class_name NPC
extends CharacterBody2D
const SPEED = 30

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None


# 导航节点
@onready var navi: NavigationAgent2D = $Navi

var trap_time = 0
var old_pos:Vector2
var is_walking = true


func _ready() -> void:
	# 开局给一个随机目标点
	navi.target_position = Vector2(randi_range(0, 1000),randi_range(0,600))


func _process(delta: float) -> void:
	if not is_walking: return
	# 如果导航结束, 开始新的导航
	if navi.is_navigation_finished():
		navi.target_position = Vector2(randi_range(0, 1000),randi_range(0,600))
		return
	
	# 新速度等于npc当前全局坐标到导航目标地点的单位向量 乘以 运动速度
	var new_velocity = global_position.direction_to(navi.get_next_path_position())* SPEED
	
	# 设置导航速度，计算安全速度
	navi.set_velocity(new_velocity)
	
	# 设置人物朝向动画
	if velocity.y <0:
		if abs(velocity.x) < abs(velocity.y):
			animated_sprite.play("run_back")
		else:
			if velocity.x >0: animated_sprite.play("run_right")
			else: animated_sprite.play("run_left")
	else:
		if abs(velocity.x) < abs(velocity.y):
			animated_sprite.play("run_front")
		else:
			if velocity.x >0: animated_sprite.play("run_right")
			else: animated_sprite.play("run_left")

	move_and_slide()
	


func _on_timer_timeout() -> void:
	if not is_walking: return
	trap_time += 1
	if trap_time == 2:
		#prints("标记位置")
		old_pos = global_position
	if trap_time == 3:
		if global_position.distance_to(old_pos) <= 16.0:
			prints("困住了")
			old_pos = global_position
			navi.target_position = Vector2(randi_range(0, 1000),randi_range(0,600))
			trap_time =0
		else:
			trap_time =0


# 导航避障的安全速度
func _on_navi_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity


# 碰到玩家说hello
func _on_talk_area_body_entered(body: Node2D) -> void:
	if body is Player:
		$Hello/HelloAnimationPlayer.play("hello")
		match animated_sprite.animation:
			"run_front":
				animated_sprite.play("idle_front")
			"run_back":
				animated_sprite.play("idle_back")
			"run_right":
				animated_sprite.play("idle_right")
			"run_left":
				animated_sprite.play("idle_left")
		is_walking = false
		velocity = Vector2.ZERO
		
		
		
		
		
		
		
		

# 玩家离开隐藏hello
func _on_talk_area_body_exited(body: Node2D) -> void:
	if body is Player:
		is_walking = true
		$Hello.hide()
