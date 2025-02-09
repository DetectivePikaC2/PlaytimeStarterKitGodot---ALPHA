extends Node

var transitioning = false

@onready var camera = $Camera3D

func transition_camera(from: Camera3D, to: Camera3D, duration: float = 1.0) -> void:
	if transitioning: return
	camera.fov = from.fov
	camera.h_offset = from.h_offset
	camera.v_offset = from.v_offset
	
	camera.global_transform = from.global_transform
	
	camera.current = true
	
	transitioning = true
	
	var tween = create_tween()
	tween.tween_property(camera, "global_transform", to.global_transform, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(camera, "fov", to.fov, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(camera, "h_offset", to.h_offset, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(camera, "v_offset", to.h_offset, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	await tween.finished
	
	to.current = true
	transitioning = false
