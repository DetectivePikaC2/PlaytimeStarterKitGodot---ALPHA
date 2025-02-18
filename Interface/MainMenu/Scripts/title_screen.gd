extends Control

@onready var title_intro = $title_intro
@onready var before_intro_screens = $BeforeIntroScreens
@onready var menu = $menu
@onready var menu_popup = $menu_popup
@onready var music = $MenuMusic/Music
@onready var render_bg = $menu/RenderBG

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	menu.visible = false
func screens_finished():
	title_intro.start()
	before_intro_screens.queue_free()
func logo_finished():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	title_intro.queue_free()
	render_bg.play()
	music.play()
	menu.visible = true


func new_game():
	#ADD YOUR NEW GAME BUTTON CODE HERE!
	var result = await menu_popup.prompt("NEW GAME", "For now, this button will take you to the example chase level.")
	if result:
		get_tree().change_scene_to_file("res://Level/test.tscn")

func quit():
	var result = await menu_popup.prompt("Exit Game", "Are you sure you wanted to exit the game?")
	if result:
		get_tree().quit()
