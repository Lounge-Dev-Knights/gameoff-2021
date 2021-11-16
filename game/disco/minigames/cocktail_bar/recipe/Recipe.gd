extends VBoxContainer


var ingredients: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for ingredient in ingredients.keys():
		var label = preload("res://game/disco/minigames/cocktail_bar/recipe/IngredientLabel.tscn").instance()
		label.ingredient = ingredient
		label.target = ingredients[ingredient]
		add_child(label)
	
	


func update_progress(content: Dictionary) -> void:
	print("update %s" % content)
	for label in get_children():
		var ingredient = label.ingredient
		if content.has(ingredient):
			label.amount = content[ingredient]
		else:
			label.amount = 0
