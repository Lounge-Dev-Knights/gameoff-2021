extends Node2D


# list of buttons pressed
onready var green = get_node("Button/TextureButton")
onready var blue = get_node("Button2/TextureButton")
onready var red = get_node("Button3/TextureButton")
onready var yellow = get_node("Button4/TextureButton")

onready var buttons = {
	1: green,
	2: blue,
	3: red,
	4: yellow
}

var rng = RandomNumberGenerator.new()

var button_order = []

# var b = "text"

func generate_order(num=1000):
	var numbers = []
	for i in num:
		numbers.append(buttons.keys()[randi() % buttons.keys().size()])
	return numbers

func play_round(order, round_number):
	var play_order = order.slice(0, round_number)
	# play sounds
	for i in play_order:
		buttons[i].emit_signal("pressed")
		yield(get_tree().create_timer(1.0), "timeout")
		
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var order = generate_order(100)
	play_round(order, 5)
	
	
	
func end_game():
	print("Oh no, you lost!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
