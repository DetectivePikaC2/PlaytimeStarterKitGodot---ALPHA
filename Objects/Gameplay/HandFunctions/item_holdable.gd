extends Node
class_name  HoldableItem

@export var hold_animation: String = "handle"

var parent = null

var holding: bool = false
var hold_hand: bool = false

func _ready():
	parent = get_parent()
	process_priority = 100

func _process(_delta):
	if holding:
		if not hold_hand:
			parent.global_transform = Grabpack.left_hand.global_transform
			Grabpack.animate_left(hold_animation)
		else:
			parent.global_transform = Grabpack.right_hand.global_transform
			Grabpack.animate_right(hold_animation)

func start_hold(hand):
	holding = true
	hold_hand = hand
	parent.collision_layer &= ~1  # Disable layer 1
	parent.collision_mask &= ~1   # Disable mask 1
func stop_hold(hand):
	holding = false
	hold_hand = hand
	parent.collision_layer |= 1  # Enable layer 1
	parent.collision_mask |= 1   # Enable mask 1
