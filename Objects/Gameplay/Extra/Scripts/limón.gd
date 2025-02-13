extends RigidBody3D

@onready var pickup = $Pickup
@onready var drop = $Drop

@onready var item_holdable = $HoldableItem
@onready var hand_grab = $HandGrab

func _hand_let_go(hand):
	if hand: if Grabpack.right_hand.holding_object: return
	if not hand: if Grabpack.left_hand.holding_object: return
	hand_grab.release_grabbed()
	hand_grab.enabled = false
	item_holdable.start_hold(hand)
	hand_grab.update_every_frame = false
	pickup.play()

func _hold_let_go():
	hand_grab.enabled = true
	hand_grab.update_every_frame = true
	drop.play()
