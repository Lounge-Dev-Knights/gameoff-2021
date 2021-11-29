extends Node2D


# list of buttons pressed
onready var red = get_node("Bug1/TextureButton")
onready var blue = get_node("Bug2/TextureButton")
onready var yellow = get_node("Bug3/TextureButton")
onready var green = get_node("Bug4/TextureButton")

onready var scoreText = get_node("CenterContainer/Score")
onready var startButton = get_node("CenterContainer/StartGame")

onready var buttons = {
	1: red,
	2: blue,
	3: yellow,
	4: green
}

var playback = false

var rng = RandomNumberGenerator.new()

var round_number = 0

var order
var play_order = []
var clicked_order = []

var score = 0


func generate_order(num=1000) -> Array:
	var numbers = []
	for i in num:
		var number = buttons.keys()[rng.randi() % buttons.keys().size()]
		numbers.append(number)
	return numbers

func play_round(round_number) -> void:
	clicked_order = []
	var current_order = order
	play_order = current_order.slice(0, round_number)
	print(play_order)
	
	# play back sequence
	playback = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	for i in play_order:
		buttons[i].emit_signal("pressed")
		yield(get_tree().create_timer(0.5), "timeout")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	playback = false


func _ready() -> void:
	set_bugs_dancing(true)
	scoreText.text = ""
	rng.randomize()
	order = generate_order(100)
	MusicEngine.play_song("Club3")
	
func set_bugs_moving(moving = true, speed = 500) -> void:
	var all_bugs = get_tree().get_nodes_in_group("bugs")
	for bug in all_bugs:
		bug.moving = moving
		bug.speed = speed

func set_bugs_dancing(dancing: bool) -> void:
	var all_bugs = get_tree().get_nodes_in_group("bugs")
	for bug in all_bugs:
		if dancing:
			bug.start_dancing()
		else:
			bug.stop_dancing()

func get_avg_bug_speed() -> float:
	var all_bugs = get_tree().get_nodes_in_group("bugs")
	var speed = 0
	for bug in all_bugs:
		speed += bug.speed
	return speed/len(all_bugs)
	
func end_round() -> void:
	if not is_sequence_correct():
		game_over()
	else:
		if is_sequence_complete():
			print("good job! playing next round")
			increase_score()
			yield(get_tree().create_timer(1.5), "timeout")	
			round_number += 1
			if round_number == 4:
				set_bugs_moving(true)
				
			if round_number == 6:
				set_bugs_moving(true, get_avg_bug_speed()+(round_number^2))
				

			play_round(round_number)
		
func game_over() -> void:
	scoreText.text = "Game over."
	print("Game over")
	
	
func increase_score() -> void:
	score += 1
	scoreText.text = str(score)


func is_sequence_complete() -> bool:
	if play_order.slice(0, round_number) == clicked_order:
		return true
	return false
	

func is_sequence_correct() -> bool:
	var full_list = play_order.duplicate()
	if clicked_order:
		for i in clicked_order:
			if not full_list.pop_front() == i:
				return false
	return true


func _on_Button1_pressed(human) -> void:
	if not playback:
		clicked_order.append(1)
		end_round()
	SoundEngine.play_sound("Bug1")


func _on_Button2_pressed(human) -> void:
	if not playback:
		clicked_order.append(2)
		end_round()
	SoundEngine.play_sound("Bug2")


func _on_Button3_pressed(human) -> void:
	if not playback:
		clicked_order.append(3)
		end_round()
	SoundEngine.play_sound("Bug3")


func _on_Button4_pressed(human) -> void:
	if not playback:
		clicked_order.append(4)
		end_round()
	SoundEngine.play_sound("Bug4")


func _on_StartGame_pressed() -> void:
	set_bugs_dancing(false)
	var tween = get_node("Tween")
	tween.interpolate_property(startButton, "modulate", 
	  Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.0, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(1.0), "timeout")

	startButton.hide()
	
	play_round(round_number)
