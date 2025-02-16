extends Node
class_name PuzzleGateLinker

##Leave blank if this doesn't connect to a gate
@export var connected_gate: StaticBody3D
##Leave blank if this doesn't connect to a door
@export var connected_door: StaticBody3D

@export var puzzle: NodePath
@export var use_enable_signal: bool = true
@export var enable_signal: String = ""
@export var use_disable_signal: bool = true
@export var disable_signal: String = ""

func _ready():
	var puzzle_node = get_node(puzzle)
	if connected_gate:
		if use_enable_signal:
			puzzle_node.connect(enable_signal, Callable(connected_gate.opengate))
		if use_disable_signal:
			puzzle_node.connect(disable_signal, Callable(connected_gate.closegate))
	if connected_door:
		if use_enable_signal:
			puzzle_node.connect(enable_signal, Callable(connected_door.opendoor))
		if use_disable_signal:
			puzzle_node.connect(disable_signal, Callable(connected_door.closedoor))
