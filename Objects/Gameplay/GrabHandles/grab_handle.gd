extends StaticBody3D

enum pull_type {
	Swing,
	PullUp
}

@export var handle_behaviour: pull_type = pull_type.Swing

var grabbed: bool = false
var physics: bool = false
var pulling_up: bool = false

@onready var pull_mark = $PullMark

func _ready():
	physics = handle_behaviour == pull_type.PullUp

func _process(delta):
	if pulling_up:
		if Grabpack.player.swinging:
			Grabpack.player.global_position = Grabpack.player.global_position.move_toward(pull_mark.global_position, 10.0 * delta)

func _on_hand_grab_grabbed(_hand):
	grabbed = true
	Grabpack.player.swinging_point = global_position
	if physics:
		pulling_up = true
	else:
		Grabpack.player.swinging = true
		Grabpack.player.hook_controller._launch_hook(global_position)

func _on_hand_grab_let_go(_hand):
	grabbed = false
	Grabpack.player.swinging = false
	if physics:
		pulling_up = false
	else:
		Grabpack.player.hook_controller._retract_hook()

func _on_hand_grab_pulled(_hand):
	if pulling_up:
		Grabpack.player.swinging = true
