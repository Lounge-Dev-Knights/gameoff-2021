tool
extends Area2D


export(String) var label_text: String = "minigame"
export(String, FILE, "*.tscn") var scene: String
export(String) var soundeffect: String


onready var label = $LabelContainer/Label
onready var animation_player = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_label_text(label_text)


func _set_label_text(new_label_text: String) -> void:
	label_text = new_label_text
	if label != null:
		label.text = label_text


func _on_MinigamePortal_mouse_entered() -> void:
	if soundeffect != "":
		SoundEngine.play_sound(soundeffect)
	animation_player.play("focus")



func _on_MinigamePortal_mouse_exited() -> void:
	animation_player.play("idle")


func _on_MinigamePortal_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		SceneLoader.goto_scene(scene)
