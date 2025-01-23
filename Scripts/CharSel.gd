extends Control

@onready var anim = $AnimationPlayer
@onready var anim2 = $AnimationPlayerL
var num = 0
var CChar = "Alex"
var NChar
var PChar
var selNum = 0
@onready var Sprite = $Spr/TempSprite

func _ready():
	GameSingleton.CharList = []
	UpdateC()
	var lastChar = GameSingleton.FullCharList[GameSingleton.FullCharList.size() - 1]
	$PrivDis.texture = load("res://Prefabs/Characters/" + lastChar + "/" + lastChar + "Select.png")
	$AnimationPlayer.play("appear")

func UpdateInc(n):
	anim2.play("RESET")
	if n == "Left":
		num-=1
		if num < 0:
			num = GameSingleton.FullCharList.size() - 1
	elif n == "Right":
		num+=1
		if num > GameSingleton.FullCharList.size() - 1:
			num = 0
	UpdateC()

func UpdateSpr():
	Sprite.loadSprite(CChar)
	Sprite.get_node("EncloseSPR/AnimatedSprite2D").canBlink = false
	Sprite.get_node("EncloseSPR/AnimatedSprite2D").play("move_down")
	$Label.text = CChar
	$AnimationPlayerL.play("LabelAppear")

func remSpr():
	if $Spr.has_node("AnimatedSprite2D"):
		$Spr.remove_child($Spr.get_node("AnimatedSprite2D"))
		$Label.text = ""

func UpdateC():
	CChar = GameSingleton.FullCharList[num]
	var Pnum = num - 1
	if Pnum > GameSingleton.FullCharList.size() - 1:
		Pnum = 0
	PChar = GameSingleton.FullCharList[Pnum]
	Pnum = num + 1
	if Pnum > GameSingleton.FullCharList.size() - 1:
		Pnum = 0
	NChar = GameSingleton.FullCharList[Pnum]
	if !GameSingleton.CompleteListCharList.has(CChar):
		$WarningLabel.visible = true
	else:
		$WarningLabel.visible = false

func UpdateTexture():
	$CurrentDis.texture = load("res://Prefabs/Characters/" + CChar + "/" + CChar + "Select.png")
	$NextDis.texture = load("res://Prefabs/Characters/" + NChar + "/" + NChar + "Select.png")
	$PrivDis.texture = load("res://Prefabs/Characters/" + PChar + "/" + PChar + "Select.png")

func _input(event):
	if event.is_action_pressed("ControllerInput"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif event.is_action_pressed("KeyboardInput"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event.is_action_pressed("ui_left") and !anim.is_playing():
		await UpdateInc("Left")
		anim.play("rotate left")
	elif event.is_action_pressed("ui_right") and !anim.is_playing():
		await UpdateInc("Right")
		anim.play("rotate right")
	if event.is_action_pressed("ui_back"):
		_on_back_pressed()
	if event.is_action_pressed("ui_accept"):
		_on_select_pressed()

func _on_l_button_pressed():
	if !anim.is_playing():
		await UpdateInc("Left")
		anim.play("rotate left")

func _on_r_button_pressed():
	if !anim.is_playing():
		await UpdateInc("Right")
		anim.play("rotate right")

func _on_select_pressed():
	if GameSingleton.CharList.size() < 4 and !GameSingleton.CharList.has(CChar):
		GameSingleton.CharList.push_back(CChar)
		selNum+=1
		get_node("HBoxContainer/TextureRect" + str(GameSingleton.CharList.size())).texture = load("res://Textures/" + CChar + "Icon.png")
	elif GameSingleton.CharList.size() >= 4:
		get_tree().change_scene_to_file("res://Scenes/Levels/test1.tscn")

func _on_back_pressed():
	if GameSingleton.CharList.size() != 0:
		get_node("HBoxContainer/TextureRect" + str(GameSingleton.CharList.size())).texture = null
		GameSingleton.CharList.pop_back()
		selNum-=1
	else:
		get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")
