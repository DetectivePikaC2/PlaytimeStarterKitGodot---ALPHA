extends Control

@onready var buttons = $section/buttons
@onready var selected = $section/Selected
@onready var tab_indecator = $Tabs/TabIndecator
@onready var item_image = $section/item_image
@onready var title = $section/title
@onready var read = $Tabs/read
@onready var decription = $section/decription

@onready var press = $Press
@onready var switch = $Switch

const INV_BUTTON = preload("res://Interface/Inventory/Scripts/inv_button.tscn")
const STYLE_SELECTED = preload("res://Interface/Inventory/Themes/StyleSelected.tres")

var previous_tab_button: Button
var previous_item_button: Button

func _ready():
	previous_tab_button = get_node("Tabs/Keys")

func load_section(section: String, tab_button: Button):
	for i in buttons.get_child_count():
		buttons.get_child(0).free()
	var section_array = Inventory.get(str("items_", section))
	for i in section_array.size():
		var new_button = INV_BUTTON.instantiate()
		buttons.add_child(new_button)
		
		new_button.text = section_array[i][0]
		new_button.position.x = 166.0
		new_button.position.y = -27.0
		new_button.position.y += 45.0 * (i+1)
		new_button.item_texture = section_array[i][1]
		
		if section_array[i].size() > 2:
			new_button.has_desc = true
			new_button.description = section_array[i][2]
		new_button.owner = get_tree().edited_scene_root
	decription.visible = false
	switch.play()
	
	if previous_tab_button:
		previous_tab_button.modulate = "ffffff64"
		previous_tab_button.remove_theme_stylebox_override("normal")
	previous_tab_button = tab_button
	tab_button.modulate = "ffffffff"
	tab_indecator.position.x = tab_button.position.x
	selected.visible = false
	item_image.visible = false
	title.text = tab_button.name
	title.visible = false
	if tab_button.name == "Notes":
		read.visible = true
	else:
		read.visible = false

func item_clicked(button_node: Button):
	if previous_item_button:
		previous_item_button.remove_theme_stylebox_override("normal")
	previous_item_button = button_node
	button_node.add_theme_stylebox_override("normal", STYLE_SELECTED)
	
	selected.position.y = button_node.position.y + buttons.position.y
	selected.visible = true
	item_image.texture = button_node.item_texture
	item_image.visible = true
	decription.visible = false
	if button_node.has_desc:
		decription.visible = true
		decription.text = button_node.description
	press.play()
