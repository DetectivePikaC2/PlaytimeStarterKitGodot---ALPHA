extends Node3D

@onready var light = $Light
@onready var hand_normal = $Skeleton3D/hand_normal
@onready var hand_powered = $Skeleton3D/hand_powered

func _ready():
	set_power(false)

func _on_hand_signal_connector_hand_launched():
	set_power(true)

func set_power(power: bool):
	light.visible = power
	hand_normal.visible = !power
	hand_powered.visible = power
