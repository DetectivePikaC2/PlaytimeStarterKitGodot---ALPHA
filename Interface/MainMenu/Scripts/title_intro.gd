extends Control

@onready var name_animation = $NameAnimation
@onready var menu_transition = $"../MenuTransition/AnimationPlayer"
@onready var pressedsfx = $"../menu/Pressed"

var awaiting: bool = false

signal pressed

func _ready():
	visible = false

func _input(_event):
	if awaiting:
		if Input.is_anything_pressed():
			menu_transition.play("transition")
			name_animation.play("pressed")
			pressedsfx.play()
			awaiting = false

func start():
	visible = true
	name_animation.play("loop")
	awaiting = true

func finished():
	pressed.emit()
