extends Node2D


# list of buttons pressed
onready var green = get_node("Button4/TextureButton")
onready var blue = get_node("Button2/TextureButton")
onready var red = get_node("Button/TextureButton")
onready var yellow = get_node("Button3/TextureButton")

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

# var b = "text"

func generate_order(num=1000):
	var numbers = []
	for i in num:
		var number = buttons.keys()[randi() % buttons.keys().size()]
		numbers.append(number)
	return numbers

func play_round(round_number):
	clicked_order = []
	var current_order = order
	play_order = current_order.slice(0, round_number)
	print(play_order)
	# play sounds
	playback = true
	for i in play_order:
		buttons[i].emit_signal("pressed")
		yield(get_tree().create_timer(1.0), "timeout")	
	playback = false

# Called when the node enters the scene tree for the first time.
func _ready():	
	order = generate_order(100)
	play_round(round_number)
	
func end_round():
	print(clicked_order)
	if not is_sequence_correct():
		game_over()
	else:
		if is_sequence_complete():
			print("good job! playing next round")
			yield(get_tree().create_timer(2.0), "timeout")	
			round_number += 1
			play_round(round_number)
		
func game_over():
	print("Game over")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func is_sequence_complete():
	if play_order.slice(0, round_number) == clicked_order:
		return true
	return false
	
func is_sequence_correct():
	var full_list = play_order.duplicate()
	if clicked_order:
		for i in clicked_order:
			if not full_list.pop_front() == i:
				return false
	return true

		

func _on_Button1_pressed(human):
	if not playback:
		clicked_order.append(1)
		end_round()

func _on_Button2_pressed(human):
	if not playback:
		clicked_order.append(2)
		end_round()

func _on_Button3_pressed(human):
	if not playback:
		clicked_order.append(3)
		end_round()

func _on_Button4_pressed(human):
	if not playback:
		clicked_order.append(4)
		end_round()
