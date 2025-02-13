extends Node3D

##The distance the player must be from the indicator for it to appear
@export var radius: float = 2.5

func _ready():
	visible = false
	$Area/CollisionShape3D.shape.radius = radius

func _on_area_body_entered(body):
	if body.is_in_group("Player"):
		visible = true

func _on_area_body_exited(body):
	if body.is_in_group("Player"):
		visible = false
