extends Area3D
class_name BasicInteraction

signal player_interacted

var colliding: bool = false

func _process(_delta):
	if not Grabpack.item_raycast:
		return
	if not Grabpack.item_raycast.is_colliding():
		return
	if Grabpack.item_raycast.get_collider() == self:
		colliding = true
	else:
		colliding = false

func _input(_event):
	if Input.is_action_just_pressed("interact"):
		if colliding:
			emit_signal("player_interacted")
