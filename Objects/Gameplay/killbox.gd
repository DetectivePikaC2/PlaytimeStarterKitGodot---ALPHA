@tool
extends Area3D
class_name KillBox

var collision:CollisionShape3D

var event_triggered = false

func _ready():
	body_entered.connect(Callable(self,"_player_entered"))

func _enter_tree() -> void:
	if get_node("CollisionShape3D") == null:
		collision = CollisionShape3D.new()
		add_child(collision)
		collision.set_owner(get_tree().edited_scene_root)
		collision.name = "CollisionShape3D"
		collision.shape = BoxShape3D.new()

func _player_entered(body) -> void:
	if body.is_in_group("Player") and not event_triggered:
		Grabpack.kill_player()
		event_triggered = true
