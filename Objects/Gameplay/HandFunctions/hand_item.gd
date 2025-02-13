extends Node3D

@onready var hand_grab = $HandGrab

@export var hand_scene: PackedScene

func collect():
	hand_grab.release_grabbed()
	
	queue_free()

func _on_hand_grab_let_go(_hand):
	collect()
func _on_basic_interaction_player_interacted():
	collect()
