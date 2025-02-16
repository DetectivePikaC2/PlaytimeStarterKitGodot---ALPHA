extends StaticBody3D

@export var locked: bool = false

@onready var animation_player = $AnimationPlayer
@onready var hand_grab = $frame/door/HandGrab
@onready var timer = $Timer
@onready var hand_grab_2 = $frame/door/HandGrab2

@onready var lockedsound = $locked_01
@onready var opensound = $open
@onready var closesound = $close

var open: bool = false

signal open_finished
signal close_finished
signal locked_attempt

func toggle():
	if locked:
		animation_player.play("locked")
		lockedsound.play()
		emit_signal("locked_attempt")
		return
	if open:
		animation_player.play("close")
		closesound.play()
	else:
		animation_player.play("open")
		opensound.play()
	open = !open

func opendoor():
	if locked:
		animation_player.play("locked")
		lockedsound.play()
		emit_signal("locked_attempt")
		return
	if not open:
		animation_player.play("open")
		opensound.play()
		open = true

func closedoor():
	if locked:
		animation_player.play("locked")
		lockedsound.play()
		emit_signal("locked_attempt")
		return
	if open:
		animation_player.play("close")
		closesound.play()
		open = false

func _on_hand_grab_grabbed(_hand):
	toggle()
	timer.start()

func _on_timer_timeout():
	hand_grab.release_grabbed()
	hand_grab_2.release_grabbed()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open":
		emit_signal("open_finished")
	elif anim_name == "close":
		emit_signal("close_finished")
