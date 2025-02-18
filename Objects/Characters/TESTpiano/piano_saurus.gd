extends Node3D

@onready var animation_player: AnimationPlayer = $pianosaurusmodel/AnimationPlayer

func step():
	var path: String = str("Step", randi_range(1, 3))
	get_node(path).play()
