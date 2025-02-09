extends Node3D

##If enabled, the jump pad will appear lit up, and will be able to be used by the players purple hand.
@export var powered: bool = true
##Hoe high the pad launches the player. Defualt value is 3.
@export var jump_height: float = 3.0

@onready var sm_jump_pad:MeshInstance3D = $SM_Jump_Pad
@onready var light = $OmniLight3D
@onready var jumped = $Jumped

const JUMP_PAD_POWERED = preload("res://Objects/Gameplay/HandFunctions/JumpPad/Mesh/jump_pad_powered.tres")

func _ready():
	set_power(powered)

func set_power(power: bool):
	var material: ORMMaterial3D = sm_jump_pad.get_surface_override_material(0)
	
	if not power:
		material.next_pass = null
	else:
		material.next_pass = JUMP_PAD_POWERED
	light.visible = power
	powered = power

func area_entered(area):
	if area.is_in_group("PurpleHand") and powered:
		var true_height = jump_height - global_position.distance_to(Grabpack.player.global_position) + 1.0
		if true_height < 0:
			true_height = 0
		jumped.play()
		Grabpack.player_jump(true_height)
		Grabpack.right_specific_rotation_axis("x", global_rotation.x-1.5)
