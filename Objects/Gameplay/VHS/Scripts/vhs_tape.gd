@tool
extends StaticBody3D

##The color of the VHS tape
@export var tape_color: Color = "ffffff"
##The title of the tape
@export var title: String = "Tape"
@export var has_description: bool = false
@export var description: String = "none"

@onready var tape_name = $TapeName
@onready var sm_vhs_tape = $SM_VHS_Tape
@onready var hand_grab = $HandGrab
@onready var inventory_item = $InventoryItem
var material: ORMMaterial3D

signal collected

func _ready():
	sm_vhs_tape = $SM_VHS_Tape
	material = sm_vhs_tape.get_surface_override_material(0)
	material.albedo_color = tape_color
	tape_name.text = title
	inventory_item.item_name = title
	if has_description:
		inventory_item.item_has_description = true
		inventory_item.item_description = description
	else:
		inventory_item.item_has_description = false

func _process(_delta):
	if Engine.is_editor_hint():
		if material == null:
			sm_vhs_tape = $SM_VHS_Tape
			material = sm_vhs_tape.get_surface_override_material(0)
		material.albedo_color = tape_color
		tape_name.text = title

func _on_hand_grab_let_go(_hand):
	hand_grab.release_grabbed()
	inventory_item.add_to_inventory()
	Grabpack.player.sound_manager.collect()
	emit_signal("collected")
	queue_free()
