extends Node

var player: CharacterBody3D = null
var grabpack: Node3D = null
var left_hand: Node3D = null
var right_hand: Node3D = null
var item_raycast: RayCast3D = null

func _ready():
	grabpack = get_tree().get_first_node_in_group("Grabpack")
	player = get_tree().get_first_node_in_group("Player")
	
	left_hand = get_tree().get_first_node_in_group("LeftHand")
	right_hand = get_tree().get_first_node_in_group("RightHand")
	
	item_raycast = get_tree().get_first_node_in_group("ItemRaycast")

#Movement Functions
func player_jump(height: float):
	player.external_jump(height)
func set_movable(value: bool):
	player.movable = value

func lower_grabpack():
	grabpack.lower_grabpack()
func raise_grabpack():
	grabpack.raise_grabpack()
func toggle_grabpack():
	if grabpack.grabpack_lowered:
		grabpack.raise_grabpack()
	else:
		grabpack.lower_grabpack()
func switch_grabpack(grabpack_idx: int):
	grabpack.switch_grabpack(grabpack_idx)

#HAND POSITION FUNCTIONS
func left_position(new_position: Vector3):
	left_hand.hand_grab_point = new_position
func left_rotation(new_rotation: Vector3):
	left_hand.rotation = new_rotation
func left_specific_rotation_axis(axis: String, value: float):
	if axis == "x":
		left_hand.rotation.x = value
	elif axis == "y":
		left_hand.rotation.y = value
	elif axis == "z":
		left_hand.rotation.z = value
func left_transform(new_position: Vector3, new_rotation: Vector3):
	left_hand.hand_grab_point = new_position
	left_hand.rotation = new_rotation
func left_cancel_auto():
	left_hand.quick_retract = false
	left_hand.timer.stop()
func left_launch():
	left_hand.launch_hand()
func left_retract():
	left_hand.retract_hand()
func animate_left(anim_name: String):
	left_hand.play_animation(anim_name)

func right_position(new_position: Vector3):
	right_hand.hand_grab_point = new_position
func right_rotation(new_rotation: Vector3):
	right_hand.rotation = new_rotation
func right_specific_rotation_axis(axis: String, value: float):
	if axis == "x":
		right_hand.rotation.x = value
	elif axis == "y":
		right_hand.rotation.y = value
	elif axis == "z":
		right_hand.rotation.z = value
func right_transform(new_position: Vector3, new_rotation: Vector3):
	right_hand.hand_grab_point = new_position
	right_hand.rotation = new_rotation
func right_cancel_auto():
	right_hand.quick_retract = false
	right_hand.timer.stop()
func right_launch():
	right_hand.launch_hand()
func right_retract():
	right_hand.retract_hand()
func animate_right(anim_name: String):
	right_hand.play_animation(anim_name)
