extends ColorRect

#Pause menu

@onready var anim = $AnimationPlayer
@onready var play_button = $CenterContainer/NinePatchRect/MarginContainer/VBoxContainer/Resume
@onready var sett_button = $CenterContainer/NinePatchRect/MarginContainer/VBoxContainer/Settings
@onready var quit_button = $CenterContainer/NinePatchRect/MarginContainer/VBoxContainer/Quit
var MouseVisable: bool
@warning_ignore("unused_signal")
signal quit

func _ready():
	if MpManager.Multip:
		$MarginContainer/Label.visible = true

#Sets game ot be unpaused and plays animation
func Unpause():
	anim.play("Unpause")
	await anim.animation_finished
	visible = false
	get_tree().paused = false

#Pauses tree and grabs focus
func Pause():
	visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$CenterContainer/NinePatchRect/MarginContainer/VBoxContainer/Resume.grab_focus()
	anim.play("Pause")
	get_tree().paused = true

#For controller
func _input(event):
	if event.is_action_released("Pause"):
		Unpause()

#Connects button to unpause
func _on_resume_pressed():
	Unpause()

#Goes to settings
func _on_settings_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/OptionsMenu.tscn")

#Goes to main menu
func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")
