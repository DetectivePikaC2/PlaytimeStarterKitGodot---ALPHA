extends Node
##Shows a tutorial message when the parent node emits a specified signal.
class_name TutorialTrigger

@export var signal_name: String = "triggered"
@export var tutorial_message: String = ""

func _ready():
	get_parent().connect(signal_name, Callable(tutorial))

func tutorial():
	Game.tutorial(tutorial_message)
