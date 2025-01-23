extends Control

@onready var t = $ColorRect/RichTextLabel
@export var input:String
var Text1:bool = true
var Text2:bool = true

func _ready():
	LoadText("Press the [shake rate=50.0 level=10 connected=1]Spookey[/shake] Button |[img=50]" + loadCont("Start") + "[/img]| to continue")

func loadCont(But:String):
	var outp:String = "res://Textures/ControllerButtons/"
	match OptionsSingleton.ConType:
		0:#Xbox
			outp = outp + "XB/"
		1:#Playstation
			outp = outp + "PS/"
		2:#Switch
			outp = outp + "SW/"
		3:#Steam Deck
			outp = outp + "SD/"
		_:
			outp = outp + "XB/"
	
	return outp + But + ".png"

func LoadText(inp:String):
	var i = 0
	var DisText:String
	while i < inp.length():
		if inp[i] == '[' and Text2:
			Text1 = false
		elif inp[i] == ']' and Text2:
			Text1 = true
		if inp[i] == '|':
			print(true)
			if Text2:
				Text2 = false
			else:
				Text2 = true
		
		if Text1 and Text2 and inp[i] != '|':
			DisText = DisText + inp[i]
			t.text = DisText
			if inp[i] != ' ':
				$AudioStreamPlayer2D.play()
			await get_tree().create_timer(.1).timeout
		else:
			if inp[i] != '|':
				DisText = DisText + inp[i]
		
		i+=1
