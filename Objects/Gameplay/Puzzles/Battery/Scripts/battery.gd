extends RigidBody3D

@onready var item_holdable = $ItemHoldable
@onready var hand_grab = $HandGrab

func _on_hand_grab_let_go(hand):
	if hand: if Grabpack.right_hand.holding_object: return
	if not hand: if Grabpack.left_hand.holding_object: return
	hand_grab.enabled = false
	item_holdable.start_hold(hand)

func _on_item_holdable_let_go():
	hand_grab.enabled = true
