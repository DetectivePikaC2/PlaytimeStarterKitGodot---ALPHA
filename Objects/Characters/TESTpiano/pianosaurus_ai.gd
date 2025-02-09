extends CharacterBody3D

var speed: float = 8.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player = $pianosaurusmodel/AnimationPlayer
@onready var timer = $Timer

var enabled: bool = false
var chasing: bool = false
var prev_look: Vector3 = transform.origin

const LERP_SPEED: float = 10.0

var point_count:int = 5

var point: Marker3D = null
var parent: Node3D = null

func _ready() -> void:
	prev_look = Vector3(1.0, 1.0, 5.0)
	point = null
	parent = get_parent()

func _process(_delta: float) -> void:
	if enabled:
		if chasing:
			_update_target_location(Grabpack.player.global_transform.origin)
		else:
			if point:
				_update_target_location(point.global_transform.origin)
			else:
				var point_path = str("Point", randi_range(1, point_count))
				if not parent:
					parent = get_parent()
				point = parent.get_node(point_path)

func _physics_process(delta):
	if enabled:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		
		prev_look = lerp(prev_look, global_transform.origin + velocity, LERP_SPEED * delta)
		look_at(prev_look)
		
		velocity = new_velocity
		move_and_slide()

func _update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_navigation_finished():
	animation_player.play("Piano_NewIdle")
	enabled = false
	chasing = false
	point = null
	timer.start()

func _on_timer_timeout():
	animation_player.play("Piano_RunLoop")
	enabled = true
