extends StaticBody3D

var grabbed: bool = false

func _on_hand_grab_grabbed(_hand):
	grabbed = true
	Grabpack.player.swinging_point = global_position
	Grabpack.player.swinging = true
	Grabpack.player.hook_controller._launch_hook(global_position)

func _on_hand_grab_let_go(_hand):
	grabbed = false
	Grabpack.player.swinging = false
	Grabpack.player.hook_controller._retract_hook()
