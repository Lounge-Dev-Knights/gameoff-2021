extends ColorRect


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mat = material as ShaderMaterial
	
	var c = mat.get_shader_param("color")
	c.h += delta * 0.05
	mat.set_shader_param("color", c)
