@tool
extends Area3D
class_name HandGrab

@export var enabled: bool = true
@export var affect_position: bool = true
@export var affect_rotation: bool = true
@export var stop_hand: bool = true
@export var grab_animation: String = "normal"
@export var grab_marker: Marker3D

signal grabbed(hand: bool)
signal pulled(hand: bool)
signal let_go(hand: bool)

var grabbed_left: bool = false
var grabbed_right: bool = false
var pulling_left: bool = false
var pulling_right: bool = false

func _ready():
	connect("area_entered", Callable(hand_grabbed))
	connect("area_exited", Callable(hand_released))

func _process(_delta):
	if not Engine.is_editor_hint():
		if grabbed_left:
			if Input.is_action_pressed("handleft") and not pulling_left:
				emit_signal("pulled")
				pulling_left = true
		if grabbed_right:
			if Input.is_action_pressed("handright") and not pulling_right:
				emit_signal("pulled")
				pulling_right = true

func hand_grabbed(area):
	if area.is_in_group("LeftHandArea") and not Grabpack.left_hand.hand_attached:
		update_hand_position(false)
	elif area.is_in_group("RightHandArea") and not Grabpack.right_hand.hand_attached:
		update_hand_position(true)
func hand_released(area):
	if area.is_in_group("LeftHandArea"):
		grabbed_left = false
		pulling_left = false
		emit_signal("let_go", false)
	elif area.is_in_group("RightHandArea"):
		grabbed_right = false
		pulling_right = false
		emit_signal("let_go", true)

func update_hand_position(hand: bool):
	if hand:
		grabbed_right = true
		if affect_position:
			Grabpack.right_position(grab_marker.global_position)
		if affect_rotation:
			Grabpack.right_rotation(grab_marker.global_rotation)
		if stop_hand:
			Grabpack.right_cancel_auto()
		Grabpack.animate_right(grab_animation)
	else:
		grabbed_left = true
		if affect_position:
			Grabpack.left_position(grab_marker.global_position)
		if affect_rotation:
			Grabpack.left_rotation(grab_marker.global_rotation)
		if stop_hand:
			Grabpack.left_cancel_auto()
		Grabpack.animate_left(grab_animation)
	emit_signal("grabbed", hand)

func release_grabbed():
	if grabbed_left:
		Grabpack.left_retract()
	if grabbed_right:
		Grabpack.right_retract()

func _enter_tree():
	if get_child_count() == 0:
		var new_collision: CollisionShape3D = CollisionShape3D.new()
		new_collision.name = "CollisionShape3D"
		add_child(new_collision)
		new_collision.owner = get_tree().edited_scene_root
		
		var new_marker: Marker3D = Marker3D.new()
		new_marker.name = "HandPositionMarker"
		add_child(new_marker)
		new_marker.owner = get_tree().edited_scene_root
		grab_marker = new_marker
