extends Button

@onready var current = $"../Current"

func _ready():
	connect("mouse_entered", Callable(entered))
	connect("mouse_exited", Callable(exited))

func entered():
	current.visible = true
	current.position.y = position.y
func exited():
	current.visible = false
