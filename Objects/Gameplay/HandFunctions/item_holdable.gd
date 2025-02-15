extends Node
class_name  HoldableItem

@export var hold_animation: String = "handle"

var parent = null

var holding: bool = false
var hold_hand: bool = false

signal let_go

func _ready():
	parent = get_parent()
	process_priority = 100

func _process(_delta):
	if holding:
		if not hold_hand:
			parent.global_transform = Grabpack.left_hand.global_transform
			Grabpack.animate_left(hold_animation)
			if not Grabpack.left_hand.holding_object:
				stop_hold(hold_hand)
		else:
			parent.global_transform = Grabpack.right_hand.global_transform
			Grabpack.animate_right(hold_animation)
			if not Grabpack.right_hand.holding_object:
				stop_hold(hold_hand)

func start_hold(hand):
	holding = true
	hold_hand = hand
	parent.collision_layer &= ~1  # Disable layer 1
	parent.collision_mask &= ~1   # Disable mask 1
	parent.freeze = true
	if hand: Grabpack.right_hand.holding_object = true
	if not hand: Grabpack.left_hand.holding_object = true
func stop_hold(hand):
	holding = false
	hold_hand = hand
	if hand: 
		Grabpack.right_hand.holding_object = false 
		Grabpack.animate_right("retract")
		Grabpack.right_seek(0.1)
		parent.global_transform = Grabpack.right_hand.hand_fake.global_transform
	if not hand: 
		Grabpack.left_hand.holding_object = false
		Grabpack.animate_left("retract")
		Grabpack.left_seek(0.1)
		parent.global_transform = Grabpack.left_hand.hand_fake.global_transform
	parent.collision_layer |= 1  # Enable layer 1
	parent.collision_mask |= 1   # Enable mask 1
	parent.freeze = false
	emit_signal("let_go")
