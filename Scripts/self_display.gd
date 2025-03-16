extends NinePatchRect

#Displays self on MPmenu

@onready var disptext = $HBoxContainer/MarginContainer/Label
@onready var dispicon = $HBoxContainer/HBoxContainer/MarginContainer2/HBoxContainer/TextureRect
var i = 0
@export var Pname:String = MpManager.MPName
var CName = "Alex"

func IsServer(t:bool):
	if t:
		$HBoxContainer/CenterContainer.visible = true
	else:
		$HBoxContainer/CenterContainer.visible = false

func _ready():
	CName = GameSingleton.FullCharList[0]

func makeLabel():
	$HBoxContainer/MarginContainer/Label.text = MpManager.MPName

#Changes Characters
func _on_left_pressed():
	if get_node("../../../../../").visible:
		i-=1
		if i < 0:
			i = GameSingleton.FullCharList.size() - 1
		dispicon.texture = load("res://Textures/" + GameSingleton.FullCharList[i] + "Icon.png")
		CName = GameSingleton.FullCharList[i]
		#print(CName + str(i))
		UpdateIcon()

func _on_right_pressed():
	if get_node("../../../../../").visible:
		i+=1
		if i > GameSingleton.FullCharList.size() - 1:
			i = 0
		dispicon.texture = load("res://Textures/" + GameSingleton.FullCharList[i] + "Icon.png")
		CName = GameSingleton.FullCharList[i]
		#print(CName)
		UpdateIcon()

#Changes Character
func UpdateIcon():
	for q in MpManager.Players:
		if q != multiplayer.get_unique_id():
			get_tree().get_root().get_node("MpMenu").UpdateOthers.rpc_id(q,MpManager.MPName, GameSingleton.FullCharList[i])
		else:
			MpManager.Players[q].CC = CName

func _input(event):#Updates UI
	if event.is_action_released("ui_left") and visible:
		_on_left_pressed()
	elif event.is_action_released("ui_right") and visible:
		_on_right_pressed()
