extends Control

# Объекты
@onready var countdown_label = $TimingPanelContainer/CountdownLabel
@onready var timer = $CountdownTimer

# Время в секундах (10 минут = 600 секунд)
var remaining_time = 600

# При запуске
func _ready():
	countdown_label.text = format_time(remaining_time)
	timer.start()

# Когда срабатывает таймер каждую секунду
func _on_CountdownTimer_timeout():
	remaining_time -= 1
	countdown_label.text = format_time(remaining_time)

	if remaining_time <= 0:
		timer.stop()

# Функция для перевода секунд в формат MM:SS
func format_time(seconds):
	var mins = seconds / 60
	var secs = seconds % 60
	return "%02d:%02d" % [mins, secs]


func _on_countdown_timer_timeout() -> void:
	remaining_time -= 1
	countdown_label.text = format_time(remaining_time)

	if remaining_time <= 0:
		timer.stop()
