extends Node2D


const INGREDIENTS := [
	preload("./ingredients/Blood.tscn"),
	preload("./ingredients/Cheese.tscn"),
	preload("./ingredients/IceCube.tscn")
]


onready var ingredient_spawner = $IngredientSpawner
onready var cocktail_shaker = $CocktailShaker
onready var recipe_note = $CanvasLayer/PanelContainer/Recipe


var current_recipe

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_recipe()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _unhandled_input(event) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		finish_drink()

func finish_drink() -> void:
	var score = check_recipe(current_recipe)
	var score_label = preload("res://game/disco/minigames/cocktail_bar/PopupLabel.tscn").instance()
	
	score_label.text = get_score_text(score)
	score_label.position = get_local_mouse_position()
	add_child(score_label)
	
	generate_recipe()

func get_score_text(score: float) -> String:
	if score >= 1.0:
		return "PERFECT!!!"
	elif score > 0.9:
		return "GREAT!"
	elif score > 0.5:
		return "NICE"
	else:
		return "HMMM..."

func generate_recipe() -> void:
	var recipe = []
	
	for _n in randi() % 5 + 3:
		var ingredient = INGREDIENTS[randi() % INGREDIENTS.size()]
		recipe.append(ingredient.resource_path.get_file().trim_suffix(".tscn"))
		
	current_recipe = recipe
	recipe_note.text = recipe_to_string(recipe)


func recipe_to_string(recipe: Array) -> String:
	var ingredients = {}
	for ingredient in recipe:
		if ingredients.has(ingredient):
			ingredients[ingredient] += 1
		else:
			ingredients[ingredient] = 1
	
	var recipe_string = ""
	for ingredient in ingredients.keys():
		recipe_string += "%dx %s\n" % [ingredients[ingredient], ingredient]
	
	return recipe_string

# checks if the cocktail shaker contains the correct ingredients and returns a score
func check_recipe(recipe: Array) -> float:
	var score := 0.0
	
	var content = cocktail_shaker.get_content()
	
	print(recipe)
	print(content)
	
	for ingredient in recipe:
		if ingredient in content:
			content.erase(ingredient)
			print("+1")
			score += 1
		else:
			score -= 1
			print("-1")
	
	score -= content.size()
	print("-" + str(content.size()))
	
	return score / recipe.size()



func spawn_ingredient() -> void:
	var shape := (ingredient_spawner.shape) as RectangleShape2D
	
	var ingredient: RigidBody2D = INGREDIENTS[randi() % INGREDIENTS.size()].instance()
	
	var spawn_position = ingredient_spawner.position + Vector2(
		rand_range(-shape.extents.x, shape.extents.x),
		rand_range(-shape.extents.y, shape.extents.y)
	)
	
	ingredient.position = spawn_position
	
	add_child(ingredient)
	
	


func _on_IngredientSpawnTimer_timeout():
	call_deferred("spawn_ingredient")


