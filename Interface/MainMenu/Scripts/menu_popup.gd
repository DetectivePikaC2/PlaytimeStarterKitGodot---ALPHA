extends Control

@onready var prompt_name = $Prompt
@onready var sub_prompt = $SubPrompt
@onready var yesbutton = $Yes
@onready var nobutton = $No
@onready var animation = $Animation

signal prompt_result(value: bool)

func _ready():
	visible = false
	yesbutton.connect("pressed", Callable(yes))
	nobutton.connect("pressed", Callable(no))

func prompt(title: String, subtitle: String):
	prompt_name.text = title
	sub_prompt.text = subtitle
	animation.play("fadein")
	
	var result: bool = await prompt_result
	
	return result

func remove():
	animation.play("fadeout")

func yes():
	prompt_result.emit(true)
func no():
	prompt_result.emit(false)
	remove()
