extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var protagonist_name = $CanvasLayer/CenterContainer/CenterContainerRight/NameCard/VBoxContainer/Name
onready var name_card = $CanvasLayer/CenterContainer/CenterContainerRight/NameCard

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Dialogic.set_variable("accessory", "Bow Tie")
	var dialog = Dialogic.start("Party Arrival")
	add_child(dialog)
	yield(dialog, "timeline_end")
	name_card.show()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_name_entered():
	Dialogic.set_variable("name", protagonist_name.text)
	
	var dialog = Dialogic.start("Name Entered")
	add_child(dialog)
	yield(dialog, "timeline_end")
	SceneLoader.goto_scene("res://game/disco/disco_overview/DiscoOverview.tscn")
