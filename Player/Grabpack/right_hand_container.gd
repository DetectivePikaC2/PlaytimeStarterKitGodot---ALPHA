extends Node3D

#SETTINGS:
@export_category("Hand Settings")

var hands: Array [PackedScene]

@onready var grabpack = $"../.."
@onready var ray_cast_3d = $"../../../Neck/RayCast3D"
@onready var direction_cast = $DirectionCast
@onready var player = $"../../.."
@onready var air_grab_point = $"../../../Neck/AirGrabPoint"

@onready var hand_pos = $"../LayerWalk/ArmRight/LayerIdle/LayerWalk/LayerCrouch/LayerJump/LayerPack/LayerSwitch/LayerShoot/HandAttach/HandPos"
@onready var hand_fake = $"../RightHandFake"
@onready var wire_container = $"../RightWireContainer"

@onready var sound_manager = $"../../../SoundManager"

@onready var hand_motions_animation = $HandMotionsAnimation
@onready var canon_right_animation = $"../CanonRightAnimation"
@onready var switch_animation = $"../SwitchAnimation"
@onready var timer = $Timer

#HAND SYSTEM
@onready var hand_parent = $Hands

var hand_queue: int = 0
var current_hand: int = 0
var current_hand_node = null

#Loaded Hand Settings

var fire_mode_launch: bool = false
var fire_mode_animation: bool = false
var fire_mode_animation_string: String = "ShootIn"
var hand_send_signals: bool = false
var hand_signal_connector: HandSignalConnector = null
var hand_useless: bool = true
var hand_animations_node: HandUseAnimations = null
var hand_uses_animations: bool = false

var hand_attached: bool = true
var hand_retracting: bool = false
var hand_travelling: bool = false
var hand_reached_point: bool = false
var hand_grab_point: Vector3 = Vector3.ZERO
var quick_retract: bool = true
var holding_object: bool = false
var hand_hold_time: float = 0.0

var retract_type = false
var hand_speed: float = 35.0
var impact_distance:float = 15.0

var exit_size: Vector3 = Vector3(1.0, 1.0, 1.0)

func _ready():
	hands = player.enabled_hands
	set_hand(0)

func _process(delta):
	if holding_object:
		if Input.is_action_pressed("handright"):
			hand_hold_time += 1.0 * delta
			if hand_hold_time > 0.5:
				holding_object = false
		elif Input.is_action_just_released("handright"):
			sort_hand_use()
			hand_hold_time = 0.0
	else:
		hand_hold_time = 0.0
		if Input.is_action_just_pressed("handright"):
			sort_hand_use()
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
				sound_manager.cable_sound(true, false)
				if quick_retract:
					timer.start()
				
				#Send Signals
				if hand_send_signals:
					hand_signal_connector.emit_signal("hand_reached_target")
		
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
				sound_manager.cable_sound(true, false)
				sound_manager.retract_hand()
				canon_right_animation.seek(0.1)
				wire_container.end_wire()
				hand_attached = true
				hand_retracting = false
				
				#Send Signals
				if hand_send_signals:
					hand_signal_connector.emit_signal("hand_finished_retract")
	
	if not holding_object:
		if Input.is_action_just_pressed("hand_up"):
			switch_hand(1, current_hand + 1)
		elif Input.is_action_just_pressed("hand_down"):
			switch_hand(1, current_hand - 1)

func _input(event: InputEvent) -> void:
	if not holding_object:
		if event is InputEventKey and event.pressed:
			if event.keycode >= KEY_0 and event.keycode <= KEY_9:
				var switch_num: int = -1
				switch_num = event.keycode - KEY_0 # Convert keycode to number
				switch_hand(1, switch_num)

func sort_hand_use():
	if not hand_useless:
		if fire_mode_launch:
			if hand_attached:
				launch_hand()
				
				#Send Signals
				if hand_send_signals:
					hand_signal_connector.emit_signal("hand_used")
			elif not hand_retracting:
				retract_hand()
		elif not hand_useless:
			fire_non_launchable()
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
	sound_manager.cable_sound(true, true)
	hand_attached = false
	hand_travelling = true
	
	position = hand_fake.global_position
	
	#Send Signals
	if hand_send_signals:
		hand_signal_connector.emit_signal("hand_launched")
func fire_non_launchable():
	if not grabpack.grabpack_usable:
		return
	if fire_mode_animation:
		canon_right_animation.play(fire_mode_animation_string)
	
	#SEND HAND SIGNALS
	if hand_send_signals:
		hand_signal_connector.emit_signal("hand_used")
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
	sound_manager.cable_sound(true, true)
	
	#Send Signals
	if hand_send_signals:
		hand_signal_connector.emit_signal("hand_started_retract")

func switch_hand(type: int, new_hand: int):
		#MAKE SURE THE HAND IS ATTACHED
		if not hand_attached:
			return
		if not grabpack.grabpack_switchable_hands:
			return
		
		queue_hand(new_hand)
		if hand_queue == current_hand:
			return
		if type == 0:
			switch_animation.play("CollectSwitch")
		elif type == 1:
			switch_animation.play("ScrewSwitch")

#HAND DATA
func set_hand(hand_index: int):
	if not current_hand_node == null:
		current_hand_node.queue_free()
		current_hand_node = null
	var new_hand = hands[hand_index].instantiate()
	hand_parent.add_child(new_hand)
	
	current_hand_node = new_hand
	current_hand = hand_index
	
	#LOAD SETTINGS:
	fire_mode_launch = new_hand.has_node("FireModeLaunch")
	fire_mode_animation = new_hand.has_node("FireModeAnimation")
	if fire_mode_animation:
		fire_mode_animation_string = new_hand.get_node("FireModeAnimation").animation_string
	hand_send_signals = new_hand.has_node("HandSignalConnector")
	if hand_send_signals:
		hand_signal_connector = new_hand.get_node("HandSignalConnector")
	hand_useless = new_hand.has_node("Useless")
	hand_uses_animations = new_hand.has_node("HandUseAnimations")
	if hand_uses_animations:
		hand_animations_node = new_hand.get_node("HandUseAnimations")

func set_queued_hand():
	set_hand(hand_queue)
func queue_hand(hand_index: int):
	hand_queue = hand_index
	
	if hand_queue < 0:
		hand_queue = 0
	if hand_queue > hands.size()-1:
		hand_queue = hands.size()-1

func play_animation(anim_name: String):
	if not hand_uses_animations:
		return
	hand_animations_node.animation_player.play(anim_name)
func seek_animation(time: float):
	if not hand_uses_animations:
		return
	hand_animations_node.animation_player.seek(time)
