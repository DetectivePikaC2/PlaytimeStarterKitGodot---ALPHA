extends Node

@onready var left_wire_container: Node3D = $"../LeftWireContainer"
@onready var right_wire_container: Node3D = $"../RightWireContainer"
@onready var crosshair: Node2D = $"../../../UI/crosshair"

@onready var left_hand_container: Node3D = $"../LeftHandContainer"
@onready var right_hand_container: Node3D = $"../RightHandContainer"

var length:float = 1.0
var max_length:float = 60.0

var sim_length: float = 1.0

func _process(_delta: float) -> void:
	length = 1.0
	var length1: float = 0.0
	var length2: float = 0.0
	if not left_hand_container.hand_attached:
		length1 = left_wire_container.get_wire_length()
		
		length -= length1
	if not right_hand_container.hand_attached:
		length2 = right_wire_container.get_wire_length()
		
		length -= length2
	sim_length = max_length - length1
	
	crosshair.set_value(length)

func get_ancor():
	return right_hand_container
