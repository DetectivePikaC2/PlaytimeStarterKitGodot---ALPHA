extends Node
class_name ScannerLinker

@export var scanners: Array[StaticBody3D]
var scanned_list: Array[bool] = []
var scanned_target: Array[bool] = []

signal scanners_finished

func _ready():
	if scanners.size() > 0:
		for i in scanners.size():
			scanned_list.append(false)
			scanned_target.append(true)
			scanners[i].connect("scan_success", Callable(scanner_success).bind(i))

func scanner_success(scanner_idx: int):
	scanned_list[scanner_idx] = true
	if scanned_list == scanned_target:
		emit_signal("scanners_finished")
