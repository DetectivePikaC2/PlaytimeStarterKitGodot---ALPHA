extends Node2D

@onready var circle = $ColorRect2

var circle_value:float = 1.0

func set_value(new_value: float):
	var material_circle: ShaderMaterial = circle.material
	
	material_circle.set_shader_parameter("value", new_value)
	circle_value = new_value
