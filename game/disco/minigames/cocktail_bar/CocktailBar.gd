extends Node2D


const INGREDIENTS := [
	preload("./ingredients/Blood.tscn"),
	preload("./ingredients/Cheese.tscn"),
	preload("./ingredients/IceCube.tscn")
]


onready var ingredient_spawner := $IngredientSpawner
onready var cocktail_shaker := $CocktailShaker
onready var score_label := $CanvasLayer/Score/VBoxContainer/ScoreLabel
onready var time_label := $CanvasLayer/Score/VBoxContainer/TimeLabel
onready var tutorial := $CanvasLayer/Tutorial
onready var game_timer := $GameTimer
onready var menu_popup := $CanvasLayer/MenuPopup
onready var menu_score := $CanvasLayer/MenuPopup/MarginContainer/VBoxContainer/Score
onready var menu_continue := $CanvasLayer/MenuPopup/MarginContainer/VBoxContainer/Continue
onready var menu_restart := $CanvasLayer/MenuPopup/MarginContainer/VBoxContainer/TryAgain
onready var menu_instructions := $CanvasLayer/MenuPopup/MarginContainer/VBoxContainer/ShowInstructions
onready var menu_exit := $CanvasLayer/MenuPopup/MarginContainer/VBoxContainer/BackToParty


onready var background := $"Background/GameBackground-Bar"


enum GameState {
	INIT,
	STARTED,
	ENDED
}


var game_state = GameState.INIT
var total_score := 0 setget _set_score


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_recipe()
	MusicEngine.play_song("Club2")



func _process(delta: float) -> void:
	update_content()
	
	# update timer
	var time_left := int(game_timer.time_left)
	time_label.text = "Time %d:%02d" % [time_left / 60, time_left % 60]
	
	# modulate background
	background.modulate.h = wrapf(background.modulate.h + delta * 0.2, 0.0, 1.0)

func clear_recipes() -> void:
	for slot in get_tree().get_nodes_in_group("recipe_slots"):
		for recipe in slot.get_children():
			recipe.free()


func start_game() -> void:
	game_state = GameState.STARTED
	clear_recipes()
	cocktail_shaker.reset_cocktail()
	generate_recipe()
	
	self.total_score = 0
	tutorial.hide()
	game_timer.start()


func finish_drink(recipe_note: Node) -> void:
	var recipe = recipe_note.ingredients
	var score = check_recipe(recipe)
	
	self.total_score += int(score * 10)
	
	recipe_note.exit()
	
	var finish_label = preload("res://game/disco/minigames/cocktail_bar/PopupLabel.tscn").instance()
	finish_label.text = get_score_text(score)
	finish_label.particles = score > 0.8
	finish_label.position = get_local_mouse_position()
	add_child(finish_label)
	cocktail_shaker.reset_cocktail()
	


func get_score_text(score: float) -> String:
	print(score)
	if score >= 1.0:
		SoundEngine.play_sound("PERFECT")
		return "PERFECT!!!"
	elif score > 0.8:
		SoundEngine.play_sound("GREAT")
		return "GREAT!"
	elif score > 0.4:
		SoundEngine.play_sound("NICE")
		return "NICE"
	else:
		SoundEngine.play_sound("OK")
		return "OK..."


func generate_recipe() -> void:
	var slots: Array
	
	if game_state == GameState.INIT:
		slots = [$RecipeSlot2]
	elif game_state == GameState.STARTED:
		slots = get_tree().get_nodes_in_group("recipe_slots")
		slots.shuffle()
	else:
		slots = []
	
	
	
	# search empty slot, and generate recipe in it when found
	for slot in slots:
		if slot.get_child_count() == 0:
			var recipe = {}
	
			for _n in randi() % 3 + 3:
				var ingredient = INGREDIENTS[randi() % INGREDIENTS.size()].resource_path.get_file().trim_suffix(".tscn")
				
				if recipe.has(ingredient):
					recipe[ingredient] += 1
				else:
					recipe[ingredient] = 1
					
			
			var recipe_note = preload("res://game/disco/minigames/cocktail_bar/recipe/Recipe.tscn").instance()
			recipe_note.ingredients = recipe
			recipe_note.connect("recipe_clicked", self, "recipe_note_clicked")
	
			
			slot.call_deferred("add_child", recipe_note)
			return


func recipe_note_clicked(recipe_note: Node) -> void:
	if cocktail_shaker.is_cocktail:
		finish_drink(recipe_note)


# checks if the cocktail shaker contains the correct ingredients and returns a score
func check_recipe(recipe: Dictionary) -> float:
	var score: int = 0
	var max_score: int = 0
	
	var content = cocktail_shaker.get_content()
	# content.clear()
	
	print("recipe: %s" % str(recipe))
	print("content: %s" % str(content))
	
	
	for ingredient in recipe.keys():
		var target = recipe[ingredient]
		max_score += target
		
		var actual = content[ingredient] if content.has(ingredient) else 0
		score += target
		score -= abs(target - actual)
		content.erase(ingredient)
	
	for remaining in content.keys():
		score -= content[remaining]
	
	
	return float(score) / float(max_score)


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


func update_content() -> void:
	var content = cocktail_shaker.get_content()
	for slot in get_tree().get_nodes_in_group("recipe_slots"):
		for recipe_note in slot.get_children():			recipe_note.update_progress(content)


func _on_RecipeTimer_timeout():
	generate_recipe()


func _set_score(new_score: int) -> void:
	total_score = new_score
	score_label.text = "Score: %3d" % new_score


func _on_Start_pressed():
	start_game()


func _on_TryAgain_pressed():
	if game_state == GameState.STARTED:
		confirm_progress_loss()
	
	menu_popup.hide()
	start_game()


func _on_ShowInstructions_pressed():
	if game_state == GameState.STARTED:
		confirm_progress_loss()
	
	tutorial.show()
	total_score = 0
	menu_popup.hide()
	


func _on_BackToParty_pressed():
	if game_state == GameState.STARTED:
		confirm_progress_loss()
		
	SceneLoader.goto_scene("res://game/disco/disco_overview/DiscoOverview.tscn")


func _on_GameTimer_timeout():
	game_state = GameState.ENDED
	
	for slot in get_tree().get_nodes_in_group("recipe_slots"):
		for recipe_note in slot.get_children():
			recipe_note.exit()
	cocktail_shaker.reset_cocktail()
	
	menu_score.text = "Score: %d" % total_score
	menu_popup.popup_centered_minsize()



func confirm_progress_loss() -> void:
	var confirm = ConfirmationDialog.new()
	confirm.dialog_text = "Are you sure?\nYour progress for the running game will be lost!"
	confirm.popup_exclusive = true
	confirm.connect("popup_hide", confirm, "queue_free")
	$CanvasLayer.add_child(confirm)
	confirm.popup_centered()
	yield(confirm, "confirmed")
	print("confirmed")


func _on_Menu_pressed():
	menu_popup.popup_centered_minsize()


func _on_MenuPopup_about_to_show():
	menu_score.visible = game_state == GameState.ENDED
	menu_continue.visible = game_state == GameState.STARTED or game_state == GameState.INIT
	menu_restart.visible = game_state == GameState.STARTED or game_state == GameState.ENDED
	menu_instructions.visible = game_state == GameState.STARTED or game_state == GameState.ENDED
	
	menu_popup.minimum_size_changed()


func _on_Continue_pressed() -> void:
	menu_popup.hide()
