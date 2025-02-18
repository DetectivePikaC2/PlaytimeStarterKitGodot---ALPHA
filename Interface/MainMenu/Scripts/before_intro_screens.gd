extends Control

@onready var menu_transition = $"../MenuTransition/AnimationPlayer"
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

@export var screens: Array[NodePath]

var current_screen: Node2D = null
var current_idx: int = 0

signal finshed

func _ready():
	play_screens()

func play_screens():
	current_idx = -1
	animation_player.play("Delay")
	menu_transition.play("transition")

func load_next():
	if current_screen:
		current_screen.visible = false
	current_idx += 1
	if screens.size() == current_idx:
		finshed.emit()
		return
	current_screen = get_node(screens[current_idx])
	current_screen.visible = true
	timer.start()

func screen_timeout():
	animation_player.play("Delay")
	menu_transition.play("transition")
