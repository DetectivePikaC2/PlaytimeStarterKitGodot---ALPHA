extends Node3D

const WIRE_SEGMENT_ONLY = preload("res://Player/Grabpack/Wire/wire_segment_only.tscn")

@export var hand_container: Node3D
@export var wire_origin: Marker3D
@export var wire_point: Marker3D

var max_wire_length: float = 60.0

func get_wire_length():
	if get_child_count() > 0:
		var child = get_child(0)
		var distance = child.position.distance_to(child.hand_node.position)
		var length = distance / max_wire_length
		return length

func start_wire():
	var only_segment = WIRE_SEGMENT_ONLY.instantiate()
	only_segment.hand_node = hand_container
	only_segment.hand_connector = wire_point
	only_segment.origin_node = wire_origin
	only_segment.visible = false
	add_child(only_segment)
func end_wire():
	for i in get_child_count():
		if get_child_count() > 0:
			get_child(0).queue_free()
