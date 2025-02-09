extends Button

@onready var inventory = $"../.."

signal pressed_with_name(name: String, button: Button)

func _ready():
	connect("pressed_with_name", Callable(inventory.load_section))

func _pressed():
	emit_signal("pressed_with_name", name, self)
