extends Node3D

@onready var grabpack = $"../.."
@onready var ray_cast_3d = $"../../../Neck/RayCast3D"
@onready var direction_cast = $DirectionCast
@onready var air_grab_point = $"../../../Neck/AirGrabPoint"

@onready var hand_pos = $"../LayerWalk/ArmLeft/LayerIdle/LayerWalk/LayerCrouch/LayerJump/LayerPack/LayerShoot/HandAttach/HandPos"
@onready var hand_fake = $"../LeftHandFake"
@onready var wire_container = $"../LeftWireContainer"

@onready var sound_manager = $"../../../SoundManager"
@onready var animation_player = $Hands/Blue/AnimationPlayer

@onready var hand_motions_animation = $HandMotionsAnimation
@onready var canon_right_animation = $"../CanonLeftAnimation"
@onready var timer = $Timer

var hand_attached: bool = true
var hand_retracting: bool = false
var hand_travelling: bool = false
var hand_reached_point: bool = false
var hand_grab_point: Vector3 = Vector3.ZERO
var quick_retract: bool = true
var holding_object: bool = false
var hand_hold_time: float = 0.0
var pulling: bool = false

var retract_type = false
var hand_speed: float = 35.0
var impact_distance:float = 15.0

var exit_size: Vector3 = Vector3(1.0, 1.0, 1.0)

func _process(delta):
	if holding_object:
		if Input.is_action_pressed("handleft"):
			hand_hold_time += 1.0 * delta
			if hand_hold_time > 0.5:
				holding_object = false
		elif Input.is_action_just_released("handleft"):
			sort_hand_use()
			hand_hold_time = 0.0
	else:
		hand_hold_time = 0.0
		if Input.is_action_just_pressed("handleft"):
			sort_hand_use()
		elif Input.is_action_just_released("handleft"):
			if pulling:
				retract_hand()
				pulling = false
	
	if hand_attached:
		global_transform = hand_pos.global_transform
	else:
		scale = exit_size
		if hand_travelling:
			position = position.move_toward(hand_grab_point, hand_speed * delta)
			if position == hand_grab_point:
				hand_reached_point = true
				hand_travelling = false
				
				hand_motions_animation.play("impact")
				sound_manager.cable_sound(false, false)
				if quick_retract:
					timer.start()
		
		if hand_reached_point:
			if not hand_grab_point == position:
				hand_travelling = true
				hand_reached_point = false
			else:
				position = hand_grab_point
		
		if hand_retracting:
			position = position.move_toward(hand_fake.global_position, hand_speed * delta)
			look_at(hand_pos.global_transform.origin)
			rotation_degrees.y += 180
			if position.distance_to(hand_fake.global_position) < 0.2:
				canon_right_animation.play("ShootOut")
				hand_motions_animation.play("retract_impact")
				play_animation("retract")
				sound_manager.retract_hand()
				sound_manager.cable_sound(false, false)
				canon_right_animation.seek(0.1)
				wire_container.end_wire()
				hand_attached = true
				hand_retracting = false

func sort_hand_use():
	if hand_attached:
		launch_hand()
	elif not hand_retracting:
		if holding_object:
			retract_hand()
		else:
			if not pulling:
				pulling = true
				sound_manager.cable_sound(false, true)
func launch_hand():
	if not grabpack.grabpack_usable:
		return
	if ray_cast_3d.is_colliding():
		hand_grab_point = ray_cast_3d.get_collision_point()
	else:
		hand_grab_point = air_grab_point.global_position
	wire_container.start_wire()
	canon_right_animation.play("ShootOut")
	play_animation("fire")
	sound_manager.launch_hand()
	sound_manager.cable_sound(false, true)
	hand_attached = false
	hand_travelling = true
		
	position = hand_fake.global_position
func retract_hand():
	if hand_attached:
		return
	if grabpack.global_position.distance_to(hand_grab_point) > impact_distance:
		retract_type = true
	else:
		retract_type = false
	hand_travelling = false
	hand_reached_point = false
	hand_retracting = true
	quick_retract = true
	
	hand_motions_animation.play("retract")
	sound_manager.cable_sound(false, true)

func play_animation(anim_name: String):
	animation_player.play(anim_name)
