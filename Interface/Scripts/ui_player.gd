extends CanvasLayer

#Objective System:
@onready var objective_animation: AnimationPlayer = $ObjectiveAnimation
@onready var obj_msg: Label = $objective/obj_msg
@onready var obj_sound = $objective/obj_sound
#Tutorial:
@onready var tutorial_text = $tutorial/text
@onready var tip_sound = $tutorial/tooltip
@onready var tutorial_animation = $TutorialAnimation
#Tooltip:
@onready var tooltip_animation = $TooltipAnimation
@onready var tooltiplabel = $tooltip/tooltiplabel
#Inventory
@onready var inventory = $inventory
@onready var open_inv = $inventory/Open
@onready var close_inv = $inventory/Close
@onready var keys = $inventory/Tabs/Keys

func _input(_event):
	if Input.is_action_just_pressed("inventory"):
		inventory.visible = !inventory.visible
		Grabpack.player.capture_mouse(!inventory.visible)
		
		get_tree().paused = inventory.visible
		if inventory.visible:
			open_inv.play()
			inventory.load_section("Keys", keys)
		else:
			close_inv.play()

func new_objective(objective: String):
	obj_msg.text = objective
	objective_animation.play("new_goal")
	obj_sound.play()
func tutorial_notify(tutorial: String):
	tutorial_text.text = tutorial
	tutorial_animation.play("tutorial")
	tip_sound.play()
func tooltip(tooltip_text: String):
	tooltiplabel.text = "Oh"
	tooltiplabel.size.x = 22.0
	tooltiplabel.position.x = 12.0
	tooltiplabel.text = tooltip_text
	tooltip_animation.play("tooltip")
	tip_sound.play()
