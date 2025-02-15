extends Node
class_name BatteryLinker

@export var battery_slots: Array[StaticBody3D]
var battery_list: Array[bool] = []
var battery_target: Array[bool] = []

signal batteries_inserted
signal batteries_taken

var complete: bool = false

func _ready():
	if battery_slots.size() > 0:
		for i in battery_slots.size():
			battery_list.append(battery_slots[i].starts_with_battery)
			battery_target.append(true)
			battery_slots[i].connect("powered_on", Callable(battery_added).bind(i))
			battery_slots[i].connect("powered_off", Callable(battery_taken).bind(i))

func battery_added(battery_idx: int):
	battery_list[battery_idx] = true
	if battery_list == battery_target:
		emit_signal("batteries_inserted")
		complete = true
func battery_taken(battery_idx: int):
	battery_list[battery_idx] = false
	if complete:
		emit_signal("batteries_taken")
		complete = false
