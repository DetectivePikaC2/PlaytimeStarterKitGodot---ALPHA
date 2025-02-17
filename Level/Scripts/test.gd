extends Node3D

@export var intro_get_up: bool = true

@onready var piano_saurus = $cutseen/PianoSaurus
@onready var pianimation = $cutseen/PianoSaurus/pianosaurusmodel/AnimationPlayer
@onready var dooranimation = $cutseen/door
@onready var camera_3d = $cutseen/Camera3D
@onready var piano_section_start = $cutseen/PianoSectionStart
@onready var ai_folder = $pianoAI
@onready var piano_start = $pianoAI/PianoStart
@onready var gate = $puzzle/Gate
@onready var gate_2 = $puzzle/Gate2
@onready var gate_3 = $puzzle/Gate3
@onready var player = $Player

var pianoAI: CharacterBody3D = null

#ChaseVars:
@onready var pianosaur = $Chase/Pianosaur
@onready var chase_animation = $Chase/AnimationPlayer
@onready var chase_cam = $Chase/ChaseCam

var chase_piano = null
var chase_piano_animation: AnimationPlayer = null

func _ready():
	pianimation.connect("animation_finished", Callable(pianimation_finished))
	if intro_get_up:
		dooranimation.play("intro")
		dooranimation.queue("afterintro")
		camera_3d.current = true
		player.visible = false
	else:
		dooranimation.play("afterintro")
		Grabpack.set_movable(true)

func done_intro():
	CameraTransition.transition_camera(camera_3d, Grabpack.player.camera, 0.2)
	player.visible = true
func fr_done_intro():
	Grabpack.raise_grabpack()
	Grabpack.set_movable(true)

func _on_hand_scanner_left_scan_success():
	piano_section_start.play()
	Grabpack.lower_grabpack()
	Grabpack.set_movable(false)
	CameraTransition.transition_camera(Grabpack.player.camera, camera_3d, 1.0)
	dooranimation.play("open")
	gate.opengate()

func start_dino_reveal():
	pianimation.play("Piano_Reveal")

func pianimation_finished(anim_name: String):
	if anim_name == "Piano_Reveal":
		pianimation.play("Piano_Roar")
		Grabpack.raise_grabpack()
		Game.set_objective("Find an exit!")
		Grabpack.set_movable(true)
	if anim_name == "Piano_Roar":
		pianimation.play("Piano_RunLoop")
		dooranimation.play("move")
	if anim_name == "Piano_PeakThrough":
		piano_saurus.queue_free()
		var ai_dino = preload("res://Objects/Characters/TESTpiano/pianosaurus_ai.tscn")
		var dinoAI = ai_dino.instantiate()
		
		dinoAI.name = "PianoAI"
		ai_folder.add_child(dinoAI)
		dinoAI.set_owner(get_tree().edited_scene_root)
		
		pianoAI = dinoAI
		pianoAI.position = piano_start.position
		pianoAI.enabled = true

func _on_event_trigger_2_triggered():
	Game.tutorial("Walk into the gap to squeeze through.")

func _on_door_animation_finished(anim_name):
	if anim_name == "open":
		CameraTransition.transition_camera(camera_3d, Grabpack.player.camera, 1.0)
	if anim_name == "move":
		pianimation.play("Piano_PeakThrough")

func chase_cutseen_start():
	Grabpack.lower_grabpack()
	Grabpack.set_movable(false)
	CameraTransition.transition_camera(Grabpack.player.camera, chase_cam, 1.0)
	chase_animation.play("chase_start")
func chase_cutseen_end1():
	CameraTransition.transition_camera(chase_cam, Grabpack.player.camera, 1.0)
func chase_cutseen_end2():
	Grabpack.raise_grabpack()
	Grabpack.set_movable(true)
	chase_animation.play("chase_run")
	chase_piano_set_animation("Piano_RunLoop")
	
	Game.set_objective("Run!")

func chase_piano_set_animation(anim_name: String, speed: float = 1.0):
	chase_piano_animation.play(anim_name)
	chase_piano_animation.speed_scale = speed

func _on_event_trigger_triggered():
	var piano_added_node = preload("res://Objects/Characters/TESTpiano/piano_saurus.tscn").instantiate()
	pianosaur.add_child(piano_added_node)
	piano_added_node.set_owner(get_tree().edited_scene_root)
	
	chase_piano = piano_added_node
	chase_piano_animation = piano_added_node.get_node("pianosaurusmodel/AnimationPlayer")
	
	chase_cutseen_start()
