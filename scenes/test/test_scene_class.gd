extends BaseScene

func _ready() -> void:
	get_tree().paused = true
	$UI/TalkBox/AnimationPlayer.play("show")


func _on_button_pressed() -> void:
	$UI/TalkBox.hide()
	get_tree().paused = false
