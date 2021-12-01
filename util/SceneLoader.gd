extends Node

# Define scenes which have to be loaded at game start
# this will reduce stuttering when changing to big scenes
var preloaded_scenes = {
	"res://game/disco/disco_overview/DiscoOverview.tscn": preload("res://game/disco/disco_overview/DiscoOverview.tscn"),
	"res://game/disco/minigames/cocktail_bar/CocktailBar.tscn": preload("res://game/disco/minigames/cocktail_bar/CocktailBar.tscn"),
	"res://game/score_screen/ScoreScreen.tscn": preload("res://game/score_screen/ScoreScreen.tscn"),
	"res://game/intro/DiscoArrival.tscn": preload("res://game/intro/DiscoArrival.tscn")
}



var fade_color := Color.black
var fade_duration := 0.5

var tween = Tween.new()

var current_scene = null

func _ready() -> void:
	add_child(tween)
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	

func goto_scene(path: String, properties: Dictionary = {}) -> void:
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path, properties)


func _set_modulate(color: Color) -> void:
	var world_canvas = get_tree().root.world_2d.canvas
	VisualServer.canvas_set_modulate(world_canvas, color)

func _deferred_goto_scene(path: String, properties: Dictionary) -> void:
	# It is now safe to remove the current scene
	# Load the new scene.
	
	
	tween.interpolate_method(self, "_set_modulate", Color.white, fade_color, fade_duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	
	var s: Resource
	
	if preloaded_scenes.has(path):
		s = preloaded_scenes[path]
	else:
		s = ResourceLoader.load(path)
		preloaded_scenes[path] = s
	
	var old_scene = current_scene
	
	# Instance the new scene.
	current_scene = s.instance()
	
	for property in properties.keys():
		current_scene.set(property, properties[property])
	
	if tween.is_active():
		yield(tween, "tween_all_completed")
	
	var root = get_tree().get_root()
	# Add it to the active scene, as child of root.
	root.add_child(current_scene)
	
	tween.interpolate_method(self, "_set_modulate", fade_color, Color.white, fade_duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

	# Optionally, to make it compatible with the 
	# SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	if old_scene:
		old_scene.free()
