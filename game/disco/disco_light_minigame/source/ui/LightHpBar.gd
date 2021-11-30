extends Control

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.red
export (float, 0, 1, 0.05) var caution_zone = 0.66
export (float, 0, 1, 0.05) var danger_zone = 0.33


func _ready() -> void:
	$theBar.value = 100

func set_percent_value(value):
	$theBar.value = value

func assign_color(value):
	if value < $theBar.max_value * danger_zone:
		$theBar.tint_progress = danger_color
	elif value < $theBar.max_value * caution_zone:
		$theBar.tint_progress = caution_color
	else:
		$theBar.tint_progress = healthy_color
