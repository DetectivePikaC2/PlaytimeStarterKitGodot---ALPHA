extends RigidBody3D

@onready var item_holdable = $ItemHoldable
@onready var hand_grab = $HandGrab

var in_holder: bool = false
var battery_holder = null

func _on_hand_grab_let_go(hand):
	if hand: if Grabpack.right_hand.holding_object: return
	if not hand: if Grabpack.left_hand.holding_object: return
	if in_holder:
		battery_holder.release_battery()
		in_holder = false
		battery_holder = null
	hand_grab.release_grabbed()
	hand_grab.enabled = false
	item_holdable.start_hold(hand)
	hand_grab.update_every_frame = false

func _on_item_holdable_let_go():
	hand_grab.enabled = true
	hand_grab.update_every_frame = true

func enable_battery():
	collision_layer |= 1  # Enable layer 1
	collision_mask |= 1   # Enable mask 1
	freeze = false
func disable_battery():
	item_holdable.stop_hold(item_holdable.hold_hand)
	collision_layer &= ~1  # Disable layer 1
	collision_mask &= ~1   # Disable mask 1
	freeze = true
