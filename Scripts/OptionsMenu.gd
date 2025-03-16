extends Control

#Options menu

var KBMvis:bool = false
var CONvis:bool = false
var setup:bool = true
@onready var resOpt = $ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Resopt
#Resolutions
var Resolution: Dictionary = {"3840x2160":Vector2i(3840,2160),
								"2560x1440":Vector2i(2560,1440),
								"1920x1080":Vector2i(1920,1080),
								"1366x768":Vector2i(1366,768),
								"1536x864":Vector2i(1536,864),
								"1280x800":Vector2i(1280,800),
								"1280x720":Vector2i(1280,720),
								"1440x900":Vector2i(1440,900),
								"1600x900":Vector2i(1600,900),
								"1024x600":Vector2i(1024,600),
								"800x600":Vector2i(800,600)}
#Controller type change
func changeConDIS():
	match OptionsSingleton.ConType:
		0:
			$ControllerDisplay.texture = load("res://Textures/ControlsXB.jpg")
		1:
			$ControllerDisplay.texture = load("res://Textures/ControlsPS.jpg")
		2:
			$ControllerDisplay.texture = load("res://Textures/ControlsNS.jpg")
		3:
			$ControllerDisplay.texture = load("res://Textures/ControlsSD.jpg")
		4:
			$ControllerDisplay.texture = load("res://Textures/ControlsWU.jpg")
		5:
			$ControllerDisplay.texture = load("res://Textures/ControlsNC.jpg")
		6:
			$ControllerDisplay.texture = load("res://Textures/ControlsDC.jpg")
		7:
			$ControllerDisplay.texture = load("res://Textures/Controls3D.jpg")


func _ready():#Sets all values to those found in optionsSingleton
	if MpManager.Multip:
		MpManager.Multip = false
		MpManager.peer = null
	
	for r in Resolution:
		resOpt.add_item(r)
	
	resOpt.selected = OptionsSingleton.res#fix this bug
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/FullCheckBox.button_pressed = OptionsSingleton.full
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ShadowsDropDown.selected = OptionsSingleton.Shadows
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ZoomSlider.value = OptionsSingleton.zoom
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/CheckButton.button_pressed = OptionsSingleton.Rumble
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer3/VBoxContainer/DiscordRich.button_pressed = OptionsSingleton.DRP
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer3/VBoxContainer/UH2Box.button_pressed = OptionsSingleton.Hypercam2
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer3/VBoxContainer/BanterBox.button_pressed = OptionsSingleton.Banter
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer3/VBoxContainer/BanterSlider.value = OptionsSingleton.BanterFreq
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer3/VBoxContainer/BanterSlider.editable = OptionsSingleton.Banter
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/SSCheckButton.button_pressed = OptionsSingleton.ScreenShake
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/UseCon.button_pressed = OptionsSingleton.UseCon
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer4/VBoxContainer/DispPingBox.button_pressed = OptionsSingleton.DispPing
	ConEnable(OptionsSingleton.UseCon)
	if OptionsSingleton.Hypercam2:
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDownJ.selected = OptionsSingleton.ConType
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDownJ.visible = true
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDown.visible = false
	else:
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDown.selected = OptionsSingleton.ConType
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDown.visible = true
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDownJ.visible = false
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Resopt.grab_focus()
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer4/VBoxContainer/PortEdit.text = str(MpManager.port)
	setup = false

#Sets all values in OptionsSingleton
func _on_shadows_drop_down_item_selected(index):
	OptionsSingleton.Shadows = index

func _on_check_button_toggled(toggled_on):
	OptionsSingleton.Rumble = toggled_on
	if toggled_on and !setup:
		Input.start_joy_vibration(0,1,1,.25)

func _on_controller_drop_down_item_selected(index):
	OptionsSingleton.ConType = index

func _on_controller_drop_down_j_item_selected(index):
	OptionsSingleton.ConType = index

func _on_button_pressed():
	get_tree().change_scene_to_file(OptionsSingleton.lastScene)

func _on_discord_rich_toggled(toggled_on):
	OptionsSingleton.DRP = toggled_on


func _on_controls_button_pressed():
	if (!KBMvis):
		$AnimationPlayer.play("DisplayKBM")
		$ColorRect/MarginContainer/ColorRect/MarginContainer/HBoxContainer2/ControlsButton.text = "Next"
		KBMvis = true
	elif(!CONvis):
		$AnimationPlayer.play("SwitchToController")
		CONvis = true
	else:
		$AnimationPlayer.play("FinishDisplay")
		$ColorRect/MarginContainer/ColorRect/MarginContainer/HBoxContainer2/ControlsButton.text = "Controls"
		KBMvis = false
		CONvis = false

func _on_resopt_item_selected(index):
	if index != 0:
		var ID = resOpt.get_item_text(index)
		get_window().size = Resolution[ID]
		OptionsSingleton.resi = Resolution[ID]
	else:
		get_window().mode = Window.MODE_FULLSCREEN
		OptionsSingleton.resi = Vector2i(0,0)
		OptionsSingleton.full = true
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/FullCheckBox.button_pressed = true
	OptionsSingleton.res = index

func _on_full_check_box_toggled(toggled_on):
	if (toggled_on):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Resopt.selected = 0
	OptionsSingleton.res = 0
	OptionsSingleton.full = toggled_on

func _on_uh_2_box_toggled(toggled_on):
	OptionsSingleton.Hypercam2 = toggled_on
	if (toggled_on):
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDown.visible = false
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDownJ.visible = true
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDownJ.selected = $ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDown.selected
	else:
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDown.visible = true
		$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDownJ.visible = false
		OptionsSingleton.DRP = $ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDown.selected

func _on_banter_box_toggled(toggled_on):
	OptionsSingleton.Banter = toggled_on
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer3/VBoxContainer/BanterSlider.editable = toggled_on


func _on_ss_check_button_toggled(toggled_on):
	OptionsSingleton.ScreenShake = toggled_on

func _on_reset_save_button_pressed():
	DirAccess.remove_absolute("user://OCCharacterSave.tres")
	DirAccess.remove_absolute("user://OCWorldSave.tres")

func _on_touch_c_button_toggled(toggled_on):
	OptionsSingleton.Touch = toggled_on

func _on_port_edit_text_submitted(new_text):
	MpManager.port = int(new_text)
	if MpManager.port == null:
		MpManager.port = 8910

func _on_use_con_toggled(toggled_on):
	OptionsSingleton.UseCon = toggled_on
	ConEnable(toggled_on)

func ConEnable(inp):
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDown.disabled = !inp
	$ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/VBoxContainer/ControllerDropDownJ.disabled = !inp

func _on_zoom_slider_drag_ended(_value_changed):
	OptionsSingleton.zoom = $ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/ZoomSlider.value


func _on_banter_slider_drag_ended(_value_changed):
	OptionsSingleton.BanterFreq = $ColorRect/MarginContainer/ColorRect/HBoxContainer/MarginContainer2/VBoxContainer/MarginContainer3/VBoxContainer/BanterSlider.value


func _on_disp_ping_box_toggled(toggled_on):
	OptionsSingleton.DispPing = toggled_on
