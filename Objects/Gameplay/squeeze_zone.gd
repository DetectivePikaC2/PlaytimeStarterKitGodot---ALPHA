@tool
extends Area3D
class_name SidleZone

@export var player_camera_angle: float = 0.0

@onready var time: Timer = $Time

var player: CharacterBody3D = null

var player_squeezing: bool = false
var entering_squeeze: bool = false

var pre_camera_movable: bool = false
var current_look_at: Vector3 = Vector3.ZERO
var player_head_clamp: Vector3 = Vector3.ZERO

var usable = true

var queue_exit = false
var colliding = false

var angle1:float = 0.0
var angle2:float = 0.0

signal player_entered
signal player_exited

func _ready():
	connect("body_entered", Callable(body_entered))
	connect("body_exited", Callable(body_exited))
	time.connect("timeout", Callable(can_exit))
	
	angle1 = player_camera_angle+1.0
	angle2 = player_camera_angle-1.0

func _process(delta):
	if player_squeezing:
		if entering_squeeze:
			current_look_at = current_look_at.move_toward(global_position, 3.0 * delta)
			player_head_clamp.y = lerp_clamp(player_head_clamp.y, angle2, angle1, 10.0 * delta)
			player_head_clamp.x = lerp_clamp(player_head_clamp.x, -0.5, 0.5, 10.0 * delta)
			
			player.neck.rotation.y = player_head_clamp.y
			player.neck.rotation.x = player_head_clamp.x
			if current_look_at == global_position:
				entering_squeeze = false
		else:
			player.camera_movable = true
			player.neck.rotation.y = clamp(player.neck.rotation.y, angle2, angle1)
			player.neck.rotation.x = clamp(player.neck.rotation.x, -0.5, 0.5)

func _enter_tree():
	if get_child_count() < 1:
		var new_collision = CollisionShape3D.new()
		new_collision.name = "CollisionShape3D"
		add_child(new_collision)
		new_collision.owner = get_tree().edited_scene_root
		var new_timer = Timer.new()
		new_timer.name = "Timer"
		new_timer.wait_time = 1.0
		add_child(new_timer)
		new_timer.owner = get_tree().edited_scene_root

func lerp_clamp(value1: float, clamp1: float, clamp2: float, clamp_speed: float):
	return value1 + (clampf(value1, clamp1, clamp2) - value1) * clamp_speed

func body_entered(body):
	if body.is_in_group("Player"):
		colliding = true
		if usable:
			player = body
			player_squeezing = true
			entering_squeeze = true
			usable = false
			time.start()
			pre_camera_movable = player.camera_movable
			current_look_at = player.camera_front.global_position
			player_head_clamp = player.neck.rotation
			
			player.camera_movable = false
			player.is_squeezing = true
			player.grabpack.lower_grabpack()
			emit_signal("player_entered")
func body_exited(body):
	if body.is_in_group("Player"):
		colliding = false
		if usable:
			player = body
			player_squeezing = false
			entering_squeeze = false
			queue_exit = false
			usable = false
			time.start()
			
			player.camera_movable = true
			player.is_squeezing = false
			player.grabpack.raise_grabpack()
			emit_signal("player_exited")
func can_exit():
	usable = true
	if player_squeezing and not colliding:
		body_exited(player)
