extends Control

#ui on screen

@onready var Icon = $ImageRect/MarginContainer/TextureRect
@onready var NIcon = $ImageRectNext/MarginContainer/TextureRect
@onready var NNIcon = $ImageRectNext2/MarginContainer/TextureRect
@onready var ToPutDispPlayer = $MPList/ScrollContainer/VBoxContainer
@export var DP: PackedScene

var LUIonscreen = false
var RUIonscreen = false
@onready var LAP = $LeftAnimationPlayer
@onready var RAP = $RightAnimationPlayer
var num = 1

func _ready():#Wait for characters to load, then set UI
	await get_tree().create_timer(.2).timeout
	Setup()
	appear()

func Setup():#Get area name, song, players etc.
	swapicon()
	GetAreaName()
	GetSongName()
	if MpManager.Multip:
		for q in MpManager.Players:
			var CurrentP = DP.instantiate()
			CurrentP.Setup(MpManager.Players[q].id)
			ToPutDispPlayer.add_child(CurrentP)
	else:
		$MPList.visible = false

func UISwap():#Play when characters seap
	if (LUIonscreen):
		LAP.play("Swap")
		await $LeftAnimationPlayer.animation_finished
	else:
		LAP.play("OFSCSwap")
		LUIonscreen = true
		await $LeftAnimationPlayer.animation_finished
		disappear()

func swapicon():#Sets new icons for characters in party
	Icon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[0] + "/TextSprites/" + GameSingleton.CharList[0] + "Image.jpeg")
	if MpManager.Multip or GameSingleton.CharList.size() == 1:
		$ImageRectNext.visible = false
	elif GameSingleton.CharList.size() == 2:
		NIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[1] + "/TextSprites/" + GameSingleton.CharList[1] + "Image.jpeg")
		NNIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[0] + "/TextSprites/" + GameSingleton.CharList[0] + "Image.jpeg")
	else:
		NIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[1] + "/TextSprites/" + GameSingleton.CharList[1] + "Image.jpeg")
		NNIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[2] + "/TextSprites/" + GameSingleton.CharList[2] + "Image.jpeg")

func revswapicon():#Sets new icons for characters in party
	Icon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[GameSingleton.CharList.size() - 1] + "/TextSprites/" + GameSingleton.CharList[GameSingleton.CharList.size() - 1] + "Image.jpeg")
	if MpManager.Multip or GameSingleton.CharList.size() == 1:
		$ImageRectNext.visible = false
	elif GameSingleton.CharList.size() == 2:
		NIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[0] + "/TextSprites/" + GameSingleton.CharList[0] + "Image.jpeg")
		NNIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[1] + "/TextSprites/" + GameSingleton.CharList[1] + "Image.jpeg")
	else:
		NIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[0] + "/TextSprites/" + GameSingleton.CharList[0] + "Image.jpeg")
		NNIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[GameSingleton.CharList.size() - 3] + "/TextSprites/" + GameSingleton.CharList[GameSingleton.CharList.size() - 3] + "Image.jpeg")

func swapiconN():#Sets new icons for characters in party
	Icon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[1] + "/TextSprites/" + GameSingleton.CharList[1] + "Image.jpeg")
	if GameSingleton.CharList.size() == 2:
		NIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[0] + "/TextSprites/" + GameSingleton.CharList[0] + "Image.jpeg")
		NNIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[1] + "/TextSprites/" + GameSingleton.CharList[1] + "Image.jpeg")
	elif GameSingleton.CharList.size() == 3:
		NIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[2] + "/TextSprites/" + GameSingleton.CharList[2] + "Image.jpeg")
		NNIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[1] + "/TextSprites/" + GameSingleton.CharList[1] + "Image.jpeg")
	else:
		NIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[2] + "/TextSprites/" + GameSingleton.CharList[2] + "Image.jpeg")
		NNIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[3] + "/TextSprites/" + GameSingleton.CharList[3] + "Image.jpeg")

func RswapiconN():#Sets new icons for characters in party
	Icon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[GameSingleton.CharList.size() - 1] + "/TextSprites/" + GameSingleton.CharList[GameSingleton.CharList.size() - 1] + "Image.jpeg")
	if GameSingleton.CharList.size() == 2:
		NIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[1] + "/TextSprites/" + GameSingleton.CharList[1] + "Image.jpeg")
		NNIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[1] + "/TextSprites/" + GameSingleton.CharList[1] + "Image.jpeg")
	else:
		NIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[0] + "/TextSprites/" + GameSingleton.CharList[0] + "Image.jpeg")
		NNIcon.texture = load("res://Prefabs/Characters/" + GameSingleton.CharList[0] + "/TextSprites/" + GameSingleton.CharList[0] + "Image.jpeg")

func GetAreaName():#Gets area name
	if (GameSingleton.Location == null):
		$AreaNameRect/MarginContainer/Label.text = "???"
	else:
		$AreaNameRect/MarginContainer/Label.text = GameSingleton.Location

func GetSongName():#gets the song
	if (GameSingleton.music == null):
		$AreaMusicRect/MarginContainer/HBoxContainer/Label.text = "???"
	else:
		$AreaMusicRect/MarginContainer/HBoxContainer/Label.text = GameSingleton.music

func appear():#Plays appear animation
	if (!LUIonscreen):
		LAP.play("LeftUI_Appear")
		LUIonscreen = true
	if (!RUIonscreen):
		RAP.play("RightUI_Appear")
		RUIonscreen = true
	await LAP.animation_finished

func disappear():#Plays disappear animpation
	if (LUIonscreen):
		LAP.play("LeftUI_Disappear")
		LUIonscreen = false
	if (RUIonscreen):
		RAP.play("RightUI_Disappear")
		RUIonscreen = false
	await LAP.animation_finished

func changeConDIS():
	match OptionsSingleton.ConType:
		0:
			$"../ControllerDisplay".texture = load("res://Textures/ControlsXB.jpg")
		1:
			$"../ControllerDisplay".texture = load("res://Textures/ControlsPS.jpg")
		2:
			$"../ControllerDisplay".texture = load("res://Textures/ControlsNS.jpg")
		3:
			$"../ControllerDisplay".texture = load("res://Textures/ControlsSD.jpg")
		4:
			$"../ControllerDisplay".texture = load("res://Textures/ControlsWU.jpg")
		5:
			$"../ControllerDisplay".texture = load("res://Textures/ControlsNC.jpg")
		6:
			$"../ControllerDisplay".texture = load("res://Textures/ControlsDC.jpg")
		7:
			$"../ControllerDisplay".texture = load("res://Textures/Controls3D.jpg")

func _input(event):#Mp UI buttons
	if event.is_action_pressed("ViewMP"):# and MpManager.Multip:
		$CenterAnimationPlayer.play("LobbyAppear")
	elif event.is_action_released("ViewMP"):# and MpManager.Multip:
		$CenterAnimationPlayer.play("LobbyDisappear")
