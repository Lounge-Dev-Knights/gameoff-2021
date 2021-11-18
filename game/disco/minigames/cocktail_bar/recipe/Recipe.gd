extends Control


var ingredients: Dictionary

onready var ingredient_container := $IngredientContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for ingredient in ingredients.keys():
		var label = preload("res://game/disco/minigames/cocktail_bar/recipe/IngredientLabel.tscn").instance()
		label.ingredient = ingredient
		label.target = ingredients[ingredient]
		ingredient_container.add_child(label)
	
	


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
