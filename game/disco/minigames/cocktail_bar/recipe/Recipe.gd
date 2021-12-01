extends Node2D

signal recipe_clicked(recipe_note)


const BUGS = [
	preload("res://game/bugs/doctor_bug/DoctorBug.tscn"),
	preload("res://game/bugs/chandelier_bug/ChandelierBUg.tscn"),
	preload("res://game/bugs/bug_queen/BugQueen.tscn"),
	preload("res://game/bugs/bug_pack/BugPack.tscn"),
	preload("res://game/bugs/light_bug/LightBug.tscn"),
	preload("res://game/bugs/light_bug/LightBug.tscn"),
	preload("res://game/bugs/nose_bug/NoseBug.tscn"),
	preload("res://game/bugs/bug_bunny/BugBunny.tscn"),
	preload("res://game/bugs/Bug_Vamp/Vamp.tscn"),
	preload("res://game/bugs/Bug_Cute/BugCute.tscn"),
	preload("res://game/bugs/Bug_Ant/BugAnt.tscn")
]


var ingredients: Dictionary

onready var ingredient_container := $PanelContainer/VBoxContainer/IngredientContainer
onready var time_left := $PanelContainer/VBoxContainer/TimeLeft
onready var timer := $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Guest.add_child(BUGS[randi() % BUGS.size()].instance())
	
	for ingredient in ingredients.keys():
		var label = preload("res://game/disco/minigames/cocktail_bar/recipe/IngredientLabel.tscn").instance()
		label.ingredient = ingredient
		label.target = ingredients[ingredient]
		ingredient_container.add_child(label)


func _process(delta: float) -> void:
	var time := int(timer.time_left)
	time_left.text = "%ds" % time
	
	if time < 5:
		time_left.modulate = Color.red
	


func update_progress(content: Dictionary) -> void:
	for label in ingredient_container.get_children():
		var ingredient = label.ingredient
		if content.has(ingredient):
			label.amount = content[ingredient]
		else:
			label.amount = 0
		
		
		if label.amount > label.target:
				label.modulate = Color.red
		elif label.amount == label.target:
			label.modulate = Color.green
		else:
			label.modulate = Color.white


func exit() -> void:
	$AnimationPlayer.play("exit")


func _on_Timer_timeout() -> void:
	exit()


func _on_PanelContainer_gui_input(event: InputEvent) -> void:
	if event.is_action("finish_drink"):
		emit_signal("recipe_clicked", self)
