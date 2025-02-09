@tool
extends StaticBody3D

##The color of the VHS Player
@export var tv_color: Color = "ffffff"
##The video file this tv plays.
@export var video: VideoStream

@onready var sm_vhs_tape = $SM_TV_Main
@onready var video_stream_player = $SubViewport/VideoStreamPlayer
@onready var static_sound = $Static
var material: ORMMaterial3D

signal video_started
signal video_ended

func _ready():
	sm_vhs_tape = $SM_TV_Main
	material = sm_vhs_tape.get_surface_override_material(0)
	material.albedo_color = tv_color

func _process(_delta):
	if Engine.is_editor_hint():
		if material == null:
			sm_vhs_tape = $SM_TV_Main
			material = sm_vhs_tape.get_surface_override_material(0)
		material.albedo_color = tv_color

func play():
	video_stream_player.stream = video
	video_stream_player.play()
	static_sound.play()
	emit_signal("video_started")

func stop():
	static_sound.stop()
	video_stream_player.stop()
	emit_signal("video_ended")

func _on_video_stream_player_finished():
	emit_signal("video_ended")
	static_sound.stop()
