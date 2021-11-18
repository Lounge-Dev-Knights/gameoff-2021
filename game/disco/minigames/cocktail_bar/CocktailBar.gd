extends Node2D


const INGREDIENTS := [
	preload("./ingredients/Blood.tscn"),
	preload("./ingredients/Cheese.tscn"),
	preload("./ingredients/IceCube.tscn")
]


onready var ingredient_spawner = $IngredientSpawner
onready var cocktail_shaker = $CocktailShaker
onready var recipe_container = $CanvasLayer/MarginContainer/RecipeContainer




# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_recipe()



func finish_drink(recipe_note: Node) -> void:
	var recipe = recipe_note.ingredients
	var score = check_recipe(recipe)
	
	recipe_note.queue_free()
	
	var score_label = preload("res://game/disco/minigames/cocktail_bar/PopupLabel.tscn").instance()
	score_label.text = get_score_text(score)
	score_label.particles = score > 0.8
	score_label.position = get_local_mouse_position()
	add_child(score_label)


func get_score_text(score: float) -> String:
	print(score)
	if score >= 1.0:
		return "PERFECT!!!"
	elif score > 0.8:
		return "GREAT!"
	elif score > 0.5:
		return "NICE"
	else:
		return "OK..."


func generate_recipe() -> void:
	var recipe = {}
	
	for _n in randi() % 5 + 3:
		var ingredient = INGREDIENTS[randi() % INGREDIENTS.size()].resource_path.get_file().trim_suffix(".tscn")
		
		if recipe.has(ingredient):
			recipe[ingredient] += 1
		else:
			recipe[ingredient] = 1
			
	
	
	var recipe_note = preload("res://game/disco/minigames/cocktail_bar/recipe/Recipe.tscn").instance()
	recipe_note.ingredients = recipe
	recipe_note.connect("gui_input", self, "_recipe_note_input", [recipe_note])
	recipe_container.call_deferred("add_child", recipe_note)
	# recipe_note.text = recipe_to_string(recipe)


func _recipe_note_input(event: InputEvent, recipe_note: Control) -> void:
	if event.is_action("finish_drink"):
		finish_drink(recipe_note)


# checks if the cocktail shaker contains the correct ingredients and returns a score
func check_recipe(recipe: Dictionary) -> float:
	var score: float = 0.0
	
	var content = cocktail_shaker.get_content(true)
	# content.clear()
	
	print("recipe: %s" % str(recipe))
	print("content: %s" % str(content))
	
	var max_score: float = 0.0
	
	for ingredient in recipe.keys():
		var target = recipe[ingredient]
		max_score += target
		var actual = content[ingredient] if content.has(ingredient) else 0
		score += target
		score -= abs(target - actual)
		content.erase(ingredient)
	
	for remaining in content.keys():
		score -= content[remaining]
	
	
	print("%d/%d" % [score, max_score])
	return score / float(max_score)


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


func _on_CocktailShaker_content_changed(content: Dictionary) -> void:
	print("update %s" % content)
	for recipe_note in recipe_container.get_children():
		recipe_note.update_progress(content)


func _on_RecipeTimer_timeout():
	if recipe_container.get_child_count() < 3:
		generate_recipe()