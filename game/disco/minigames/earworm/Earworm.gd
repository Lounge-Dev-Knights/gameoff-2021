extends Node2D


# list of buttons pressed
onready var red = get_node("Bug1/TextureButton")
onready var blue = get_node("Bug2/TextureButton")
onready var yellow = get_node("Bug3/TextureButton")
onready var green = get_node("Bug4/TextureButton")

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
		var number = buttons.keys()[randi() % buttons.keys().size()]
		numbers.append(number)
	return numbers

func play_round(round_number) -> void:
	clicked_order = []
	var current_order = order
	play_order = current_order.slice(0, round_number)
	print(play_order)
	
	# play back sequence
	playback = true
	for i in play_order:
		buttons[i].emit_signal("pressed")
		yield(get_tree().create_timer(1.0), "timeout")	
	playback = false


func _ready() -> void:
	$Score.text = ""
	order = generate_order(100)
	MusicEngine.play_song("Club3")
	
	
func end_round() -> void:
	if not is_sequence_correct():
		game_over()
	else:
		if is_sequence_complete():
			print("good job! playing next round")
			increase_score()
			yield(get_tree().create_timer(2.0), "timeout")	
			round_number += 1
			play_round(round_number)
		
func game_over() -> void:
	$Score.text = "Game over."
	print("Game over")
	
	
func increase_score() -> void:
	score += 1
	$Score.text = "Score: " + str(score)


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


func _on_Button2_pressed(human) -> void:
	if not playback:
		clicked_order.append(2)
		end_round()


func _on_Button3_pressed(human) -> void:
	if not playback:
		clicked_order.append(3)
		end_round()


func _on_Button4_pressed(human) -> void:
	if not playback:
		clicked_order.append(4)
		end_round()


func _on_StartGame_pressed() -> void:
	play_round(round_number)
	$StartGame.hide()
