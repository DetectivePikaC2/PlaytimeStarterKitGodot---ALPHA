extends RayCast3D

@onready var sound_manager: Node = $"../SoundManager"

# Variable to track the last object the raycast was colliding with
var last_collided_object: Object = null

func _physics_process(_delta: float) -> void:
	# Check if the raycast is colliding
	if is_colliding():
		var current_object = get_collider()
		
		if current_object != last_collided_object:
			if current_object:
				if current_object.has_node("FootStepSurface"):
					var surfacesound: FootStepSurface = current_object.get_node("FootStepSurface")
					sound_manager.load_soundpack(surfacesound.surfaces.keys()[surfacesound.surface])
				else:
					sound_manager.load_soundpack("Concrete")
			
			last_collided_object = current_object
