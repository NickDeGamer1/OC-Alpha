extends NinePatchRect

@onready var disptext = $HBoxContainer/MarginContainer/Label
@onready var dispicon = $HBoxContainer/HBoxContainer/MarginContainer2/HBoxContainer/TextureRect
var Name:String
var i = 0
@export var Pname:String = "Alex"
var CName = GameSingleton.FullCharList[0]

func setLabel(N):
	visible = true
	Pname = N
	Name = N
	$HBoxContainer/MarginContainer/Label.text = N

func reset():
	Name = ""
	i = 0
	Pname = "Alex"
	CName = "Alex"
	visible = false

func setKick():
	$HBoxContainer/HBoxContainer/MarginContainer3.visible = true

func setChar(inp):
	$HBoxContainer/HBoxContainer/MarginContainer2/HBoxContainer/TextureRect.texture = load("res://Textures/" + inp + "Icon.png")

func _on_kick_button_pressed():
	get_node("../../../../../../../").KickPlayer(i)
