extends Button

@onready var inventory = $"../../.."

var has_desc: bool = false
var description: String = "none"
var item_texture: Texture2D

func _ready():
	connect("pressed", Callable(inventory, "item_clicked").bind(self))
