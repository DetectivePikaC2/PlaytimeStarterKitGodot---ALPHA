extends Node

var hud = null

var current_objective = "none"

func reset_nodes():
	if not get_tree().get_first_node_in_group("HUD") == null:
		hud = get_tree().get_first_node_in_group("HUD")

func set_objective(objective: String):
	hud.new_objective(objective)
	current_objective = objective
func tutorial(tutorial_text: String):
	hud.tutorial_notify(tutorial_text)
func tooltip(tooltip_text: String):
	hud.tooltip(tooltip_text)
