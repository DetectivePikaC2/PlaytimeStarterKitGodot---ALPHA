@tool
extends StaticBody3D

##The color of the VHS Player
@export var player_color: Color = "ffffff"
##The name of the VHS tape that is required for this player.
@export var vhs_name: String = "none"
##The tv this VHS player connects to.
@export var tv: StaticBody3D

@onready var sm_vhs_player = $SM_VHS_Player
@onready var sm_vhs_tape = $SM_VHS_Tape
@onready var animation_player = $AnimationPlayer
@onready var insert = $Insert
var material: ORMMaterial3D
var tape_material: ORMMaterial3D

var used: bool = false

signal tape_inserted

func _ready():
	sm_vhs_player = $SM_VHS_Player
	sm_vhs_tape = $SM_VHS_Tape
	material = sm_vhs_player.get_surface_override_material(0)
	material.albedo_color = player_color
	tape_material = sm_vhs_tape.get_surface_override_material(0)
	tape_material.albedo_color = player_color
	sm_vhs_tape.visible = false

func _process(_delta):
	if Engine.is_editor_hint():
		if material == null:
			sm_vhs_player = $SM_VHS_Player
			material = sm_vhs_player.get_surface_override_material(0)
		material.albedo_color = player_color

func _on_interaction_player_interacted():
	if not used:
		if Inventory.scan_list("items_VHS", vhs_name):
			Inventory.remove_item("items_VHS", vhs_name)
			animation_player.play("insert")
			insert.play()
			sm_vhs_tape.visible = true
			emit_signal("tape_inserted")
			
			used = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "insert":
		tv.play()
