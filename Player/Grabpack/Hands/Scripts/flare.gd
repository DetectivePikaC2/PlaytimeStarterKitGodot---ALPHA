extends Node3D

@onready var animation_player = $AnimationPlayer

func _on_hand_signal_connector_hand_used():
	animation_player.play("shoot")
