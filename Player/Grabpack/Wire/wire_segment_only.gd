extends Area3D

var hand_node
var origin_node
var hand_connector

func _process(_delta):
	if not hand_node == null:
		look_at(hand_connector.global_transform.origin)
		scale.z = global_transform.origin.distance_to(hand_connector.global_transform.origin)
	if not origin_node == null:
		global_transform.origin = origin_node.global_transform.origin

func _on_timer_timeout():
	visible = true
