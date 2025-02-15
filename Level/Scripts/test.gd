extends Node3D

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

func _ready():
	pianimation.connect("animation_finished", Callable(pianimation_finished))
	dooranimation.play("intro")
	camera_3d.current = true
	player.visible = false

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

func _on_battery_linker_batteries_inserted():
	gate_2.opengate()
func _on_battery_linker_batteries_taken():
	gate_2.closegate()

func _on_battery_linker_2_batteries_inserted():
	gate_3.opengate()
func _on_battery_linker_2_batteries_taken():
	gate_3.closegate()
