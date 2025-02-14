extends Area3D
class_name BasicInteraction

signal player_interacted

var colliding: bool = false

func _ready():
	collision_layer &= ~1  # Disable layer 1
	collision_mask &= ~1   # Disable mask 1
	collision_layer |= 2  # Enable layer 1
	collision_mask |= 2   # Enable mask 1

func _process(_delta):
	if not Grabpack.item_raycast:
		return
	if not Grabpack.item_raycast.is_colliding():
		colliding = false
		return
	else:
		if Grabpack.item_raycast.get_collider() == self:
			colliding = true
		else:
			colliding = false

func _input(_event):
	if Input.is_action_just_pressed("interact"):
		if colliding:
			emit_signal("player_interacted")
