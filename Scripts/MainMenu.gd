extends Control

var funnetext = ["100% Vegan!", "Splash text idea possibly stolen\nfrom Minecraft!", "Legal in most countries!",
					"Squid Games!", "Sub2SansGaming!", "Only 90's kids remember!", "One of us!",
					"Illegal in North Korea!", "Written by a Friend of a member\n of the alphabet mafia!", "Uses they/them pronouns!",
					"Whoops, can't put that in a\nChristian Manga!", "This game's code is written horribly!",
					"Still in Alpha!", "You've Got Mail!", "Lore by NickDeGamer1!",
					"OC 2 When?????", "0 Copies Sold!", "Fortnite Battle Pass!", "cout << " + char(34) + "not written in C++!" + char(34) + " << endl;", "System.out.print(" + char(34) + "Not coded in java" + char(34) + ")",
					"printf(" + char(34) + "Not coded in C" + char(34) + ");", "Please stop seducing things!", "Shut up Alex, or I'll\nthrow you in the water!", "Kick down the Door!",
					"Not a virus!", "Sponsored by Liberty Mutual!", "Sponsored by Red Lobster!", "Help, the Furries have me hostage!",
					"This will be OC in 2013!", "Made in Godot!", "Delete System32!","Clint Eastwood", "|          |    | \n\n | i       |  _", "Not mining crypto,\nit's just poorly optamised",
					"Better than Twitter","Better than 𝕏\n(We don't call it that)", "Do not steal!!!1!", "Mine dimonds", "https://youtu.be/n6Hm4LZv1sU",
					"Rolled a 1", "Rolled a 20", "What the F&%* is insurence?", "Shack O'neal Pregnency Test", "Waddup", "What other splash text should I\nadd to the menu?",
					"If yo leg got cut off,\nWhere would it hurt?", "You lost the Game :)", "I NEEEEEEED a\nMedic Bag!", "Are ya winning son?", "Will release... Eventually"]

var MouseVisable
@onready var Manim = $MenuAnimPlayer
@onready var Sanim = $SplashAnimPlayer
@onready var Menu1 = $MarginContainer/Menu1
@onready var Menu2 = $MarginContainer/Menu2
@onready var Splash = $Control/Sprite2D/SplashText
@onready var Ver = $MarginContainer2/Label
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if MpManager.Multip:
		MpManager.Multip = false
		MpManager.peer = null
	
	MpManager.MPhost = false
	
	if MpManager.Kicked:
		$CenterContainer/Err/CenterContainer/VBoxContainer/Label.text = "Disconnected:\n" + MpManager.KR
		$CenterContainer.visible = true
		MpManager.KR = ""
		MpManager.Kicked = false
	else:
		$CenterContainer.visible = false
	
	OptionsSingleton.lastScene = "res://Scenes/Menus/MainMenu.tscn"
	Menu1.visible = true
	if (OptionsSingleton.TitleAnim):
		Manim.play("Menu1Appear")
		OptionsSingleton.TitleAnim = false
	else:
		$MarginContainer/Menu1/StartButton.grab_focus()
	
	var day = Time.get_date_string_from_system()
	if day.contains("-02-19"):
		Splash.text = "Happy Birthday Nick!!!"
		funnetext.append("Happy Birthday Nick!!!")
	elif day.contains("-07-30"):
		Splash.text = "Happy Birthday Yuna!!! ILY <3"
		funnetext.append("Happy Birthday Yuna!!! ILY <3")
	elif day.contains("-07-26"):
		Splash.text = "Happy Anniversery Yuna and Nick!"
		funnetext.append("Happy Anniversery Yuna and Nick!")
	elif day.contains("-04-20"):
		Splash.text = "hehe, funne weed day"
		funnetext.append("hehe, funne weed day")
	elif day.contains("69"):
		funnetext.append("Nice")
	else:
		Splash.text = funnetext.pick_random()
	Sanim.play("Splash")
	Ver.text = Ver.text + OptionsSingleton.ver

func _input(event):
	if event.is_action_pressed("ControllerInput"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		MouseVisable = false
	elif event.is_action_pressed("KeyboardInput"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		MouseVisable = true
	
	if event.is_action_pressed("ui_back") and ($MarginContainer/Menu2.visible):
		Manim.play("Menu2Disappear")
		Menu1.visible = true
		Menu2.visible = false
		Manim.play("Menu1JustTextAppear")
	
	if event.is_action_pressed("rev_swap"):
		_on_splash_text_pressed()

func _on_start_button_pressed():
	Manim.play("Menu1Disappear")
	Menu1.visible = false
	Menu2.visible = true
	Manim.play("Menu2Appear")
	await Manim.animation_finished

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/OptionsMenu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_single_player_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/CharSel.tscn")

func _on_multiplayer_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/MpMenu.tscn")

func _on_back_button_pressed():
	Manim.play("Menu2Disappear")
	Menu1.visible = true
	Menu2.visible = false
	Manim.play("Menu1JustTextAppear")

func GFmenu1():
	$MarginContainer/Menu1/StartButton.grab_focus()

func GFmenu2():
	$MarginContainer/Menu2/SinglePlayerButton.grab_focus()


func _on_splash_text_pressed():
		Splash.text = funnetext.pick_random()

func _on_err_ok_buttton_pressed():
	$CenterContainer.visible = false
	$MarginContainer/Menu1/StartButton.grab_focus()
