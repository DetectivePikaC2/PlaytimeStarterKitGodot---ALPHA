extends RigidBody3D

@onready var item_holdable = $ItemHoldable

func _on_hand_grab_grabbed(hand):
	pass # Replace with function body.

func _on_hand_grab_let_go(hand):
	item_holdable.start_hold(hand)
