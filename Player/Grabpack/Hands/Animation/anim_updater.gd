@tool
extends Node3D

@export var wow = false

func _process(delta):
	if wow:
		update_anim()
		wow = false

func update_anim():
	var anim_player = $AnimationPlayer  # Adjust to your actual AnimationPlayer path
	if anim_player:
		for animation_name in anim_player.get_animation_list():
			var animation = anim_player.get_animation(animation_name)
			for i in range(animation.get_track_count()):
				var old_path = animation.track_get_path(i)
				if old_path.is_empty():
					continue
				# Adjust the path to match the new skeleton location
				var skelewel: Skeleton3D = get_node("HandScale/Skeleton3D2")
				var new_path = get_new_path(old_path)
				var bone_name = get_bone_hierarchy_path(skelewel, i)
				print(bone_name)
				animation.track_set_path(i, str(new_path,":", bone_name))
				

func get_new_path(old_path: NodePath) -> NodePath:
	# Modify this function to correctly adjust the path
	var new_base_path = "HandScale/Skeleton3D2"  # Adjust this to your new skeleton node
	return new_base_path
func get_bone_hierarchy_path(skeleton: Skeleton3D, bone_index: int) -> String:
	var hierarchy = []
	while bone_index != -1:  # -1 means no parent (root bone)
		hierarchy.insert(0, skeleton.get_bone_name(bone_index))  # Insert at the start
		bone_index = skeleton.get_bone_parent(bone_index)  # Move up the hierarchy
	return "/".join(hierarchy)  # Convert array to string path
